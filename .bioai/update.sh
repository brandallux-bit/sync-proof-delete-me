#!/bin/sh
# The BioAI coach folder's start-up script. Claude Code runs it at the start of every session (the SessionStart hook in
# .claude/settings.json). It fetches the current coach file by file from the public repository's bundle/ folder, checks
# all of it, and swaps it in: .bioai/rules.md, .bioai/reviewers/, .claude/skills/, .claude/agents/ (each reviewer's
# agent file, written here from a four-line spec the bundle holds and this script checks), .claude/settings.local.json
# (only while it is the one the script wrote, by the sum in .bioai/settings.sha256), .bioai/AGENTS and .bioai/MANIFEST
# (the lists applied), and .bioai/VERSION last. It writes nothing else and nowhere else, git ignores all of it, and it
# always exits 0, so a session always starts. The repository can change what the coach is told, and a reviewer's name,
# description, model and tools, the tools only among Read and BioAI's own get_ and report_ tools. It can't change this
# script, and it can't pre-approve anything but BioAI's own tools.
#
# POSIX sh only (macOS and Linux). Its source is tools/workspace/src/update.sh in the platform repository, copied in by
# `pnpm workspace:publish`; it is part of the folder's fixed files and never refreshes itself.

FORMAT_SUPPORTED=1
AGENTS_FORMAT_SUPPORTED=1
DEFAULT_BASE=https://raw.githubusercontent.com/brandallux-bit/bioai-coach/main/bundle
READ_LINE='Read .bioai/rules.md now, all of it, before you reply.'
MAX_FILES=400
# The hook is given 60 seconds (UPDATE_HOOK in layout.ts). The clock starts before the first fetch and counts the
# manifest's and the list's. No fetch starts after 30 s, and a fetch takes 8 s at most (--max-time), so the last one
# ends by 38 s. What can follow is a set-up from the folder's own bundle: local copies and sums of at most 400 files, about
# 30 ms each, 12 s at the worst. 38 + 12 = 50 s, ten to spare. The local copies aren't held to the clock: nothing is
# waited for. A test holds this sum.
DEADLINE_SECONDS=30
# Ends the first line of every message but one: it says what this script is, not what happened, so the coach can tell a
# copy that has it from an older one. A reviewers' list newer than this script drops it and says so instead.
MARKER=' This copy writes its own reviewers.'
# What a reviewers' list newer than this script comes to: its reviewers are left as they are, or, when there are none (a
# cloud session starts from a fresh copy, with nothing ignored on disk), built from the folder's own bundle, or still none.
NEWER_NOTE="The reviewers' list is newer than this copy, so its reviewers were left as they are."
NEWER_BUILT_NOTE="The reviewers' list is newer than this copy, so its reviewers came from the copy that came with the folder."
NEWER_NONE_NOTE="The reviewers' list is newer than this copy, and the copy that came with the folder couldn't give it any, so it has no reviewers."

# The allow-lists. tools/workspace/src/layout.ts holds the same patterns, and a test holds the two together.
PATH_PATTERN='^(rules\.md|tools\.txt|skills/[a-z0-9-]+/[A-Za-z0-9_-][A-Za-z0-9._-]*|reviewers/[a-z0-9-]+\.md)$'
TOOL_PATTERN='^mcp__claude_ai_BioAI__[a-z0-9_]+$'
VERSION_CHARS='A-Za-z0-9._-'
# What a reviewer's spec may hold. A reviewer may hold Read and BioAI's get_ and report_ tools by exact name, under either
# name a session gives them: never a saving tool, never a partial name, never the whole connector.
AGENT_ENTRY_PATTERN='^[0-9a-f]{64}  agent-specs/[a-z0-9-]+\.txt$'
AGENT_DESCRIPTION_PATTERN="^[A-Za-z][A-Za-z0-9 ,.;'()/-]*\$"
AGENT_DESCRIPTION_MAX=400
AGENT_MODELS='sonnet haiku opus inherit'
AGENT_TOOL_PATTERN='^(Read|mcp__(BioAI|claude_ai_BioAI)__(get|report)_[a-z0-9_]+)$'
AGENT_TOOLS_MAX=64
AGENT_TOOLS_CHARS_MAX=4000
AGENT_SPEC_BYTES_MAX=6000
# A reviewer's name starts with a letter and is never one of these: words YAML reads as a boolean or null, and the
# built-in subagents' names. layout.ts holds the same list.
AGENT_RESERVED_NAMES='true false null yes no on off y n general-purpose explore plan statusline-setup claude-code-guide output-style-setup claude web-fetch'

LC_ALL=C
export LC_ALL

# Only the final message goes to stdout: Claude Code hands it to the coach. Everything else is silenced.
exec 3>&1 >/dev/null 2>&1

LOCK=''
WORK=''
FAIL=''
REASON=''
M_TEXT=''
M_VERSION=''
A_TEXT=''
A_ENTRIES=''
A_NEWER=''
A_NOTE=''
STARTED=''

cleanup() {
  if [ -n "$WORK" ]; then rm -rf "$WORK"; WORK=''; fi
  if [ -n "$LOCK" ]; then rmdir "$LOCK"; LOCK=''; fi
}
trap cleanup EXIT
trap 'exit 0' HUP INT TERM

# Prints the message and the read instruction, and ends the script.
finish() {
  cleanup
  note=$MARKER
  if [ -n "$A_NEWER" ]; then note=" ${A_NOTE:-$NEWER_NOTE}"; fi
  printf 'BioAI coach folder: %s%s\n%s\n' "$1" "$note" "$READ_LINE" >&3
  exit 0
}

# The version written last time, or nothing when it isn't there or isn't one.
current_version() {
  [ -f .bioai/VERSION ] || return 0
  v=$(sed -n '1p' .bioai/VERSION)
  case "$v" in
    '' | *[!$VERSION_CHARS]*) ;;
    *) printf '%s' "$v" ;;
  esac
}

# Says "version X", or that there is none yet.
in_use() {
  v=$(current_version)
  if [ -n "$v" ]; then printf 'version %s' "$v"; else printf 'no version yet'; fi
}

# Everything the coach needs from the script is there. The settings file isn't required: once the person or Claude
# Code has changed it, it is theirs. Nor is the agents folder, when the reviewers' list is one this script can't read: it
# leaves the reviewers alone then.
installed() {
  [ -f .bioai/rules.md ] && [ -d .bioai/reviewers ] && [ -d .claude/skills ] && [ -n "$(current_version)" ] &&
    { [ -d .claude/agents ] || [ -n "$A_NEWER" ]; }
}

# The manifest and the reviewers' list applied last time are byte for byte the ones just read, and everything is there:
# nothing to do. A reviewers' list this script can't read is never kept, so only the manifest is compared then.
current() {
  installed && [ -f .bioai/MANIFEST ] && [ "$(cat .bioai/MANIFEST)" = "$M_TEXT" ] &&
    { [ -n "$A_NEWER" ] || { [ -f .bioai/AGENTS ] && [ "$(cat .bioai/AGENTS)" = "$A_TEXT" ]; }; }
}

# The settings file is the script's to replace: absent, or exactly as the script last wrote it.
settings_are_ours() {
  [ -e .claude/settings.local.json ] || return 0
  [ -f .bioai/settings.sha256 ] || return 1
  [ "$($HASHER < .claude/settings.local.json | cut -d' ' -f1)" = "$(sed -n '1p' .bioai/settings.sha256)" ]
}

refuse() {
  FAIL=refused
  REASON=$1
  return 1
}

# Copies one bundle file ($2) into $3, from the address ($1 = remote) or the folder's own bundle/ ($1 = local).
get() {
  if [ "$1" = local ]; then
    [ -f "bundle/$2" ] && [ ! -h "bundle/$2" ] && [ ! -h "bundle/$(dirname "$2")" ] && cp "bundle/$2" "$3"
  else
    curl -q --silent --fail --proto "$PROTO" --connect-timeout 5 --max-time 8 --max-filesize 5000000 \
      --output "$3" "$BASE/$2"
  fi
}

# Reads and checks the manifest from $1 (remote or local) into M_TEXT and M_VERSION, writing nothing.
read_manifest() {
  if [ "$1" = local ]; then
    if [ -f bundle/MANIFEST ] && [ ! -h bundle ] && [ ! -h bundle/MANIFEST ]; then
      M_TEXT=$(cat bundle/MANIFEST) || M_TEXT=''
    else
      M_TEXT=''
    fi
    if [ -z "$M_TEXT" ]; then
      FAIL=unreachable
      REASON="the folder's own copy is missing"
      return 1
    fi
  else
    if ! M_TEXT=$(curl -q --silent --fail --proto "$PROTO" --connect-timeout 5 --max-time 8 --max-filesize 100000 \
      "$BASE/MANIFEST"); then
      FAIL=unreachable
      REASON='no connection'
      return 1
    fi
  fi
  first=$(printf '%s\n' "$M_TEXT" | sed -n '1p')
  second=$(printf '%s\n' "$M_TEXT" | sed -n '2p')
  case "$first" in
    'format '*) n=${first#format } ;;
    *) refuse 'its list of files is malformed' ; return 1 ;;
  esac
  case "$n" in
    '' | *[!0-9]*) refuse 'its list of files is malformed' ; return 1 ;;
  esac
  if [ ${#n} -gt 6 ] || [ "$n" -gt "$FORMAT_SUPPORTED" ]; then
    FAIL=toonew
    REASON='the coach folder is too old for the current coach'
    return 1
  fi
  [ "$n" -eq "$FORMAT_SUPPORTED" ] || { refuse 'its list of files is malformed' ; return 1 ; }
  case "$second" in
    'version '*) M_VERSION=${second#version } ;;
    *) refuse 'its list of files is malformed' ; return 1 ;;
  esac
  case "$M_VERSION" in
    '' | *[!$VERSION_CHARS]*) refuse 'its list of files is malformed' ; return 1 ;;
  esac
  [ ${#M_VERSION} -le 64 ] || { refuse 'its list of files is malformed' ; return 1 ; }
  return 0
}

# Reads and checks the reviewers' list from $1 (remote or local) into A_TEXT and A_ENTRIES, writing nothing. It must
# belong to the manifest just read (the same version). A list of a newer format is not read: A_NEWER says so, and the
# update leaves the reviewers as they are.
read_agents() {
  A_TEXT=''
  A_ENTRIES=''
  A_NEWER=''
  if [ "$1" = local ]; then
    if [ -f bundle/AGENTS ] && [ ! -h bundle ] && [ ! -h bundle/AGENTS ]; then
      A_TEXT=$(cat bundle/AGENTS) || A_TEXT=''
    fi
    if [ -z "$A_TEXT" ]; then
      refuse "the folder's own copy has no list of reviewers"
      return 1
    fi
  else
    if ! A_TEXT=$(curl -q --silent --fail --proto "$PROTO" --connect-timeout 5 --max-time 8 --max-filesize 100000 \
      "$BASE/AGENTS"); then
      FAIL=unreachable
      REASON="its list of reviewers couldn't be fetched"
      return 1
    fi
  fi
  first=$(printf '%s\n' "$A_TEXT" | sed -n '1p')
  second=$(printf '%s\n' "$A_TEXT" | sed -n '2p')
  case "$first" in
    'format '*) n=${first#format } ;;
    *) refuse 'its list of reviewers is malformed' ; return 1 ;;
  esac
  case "$n" in
    '' | *[!0-9]*) refuse 'its list of reviewers is malformed' ; return 1 ;;
  esac
  if [ ${#n} -gt 6 ] || [ "$n" -gt "$AGENTS_FORMAT_SUPPORTED" ]; then
    A_NEWER=1
    return 0
  fi
  [ "$n" -eq "$AGENTS_FORMAT_SUPPORTED" ] || { refuse 'its list of reviewers is malformed' ; return 1 ; }
  case "$second" in
    'version '*) ;;
    *) refuse 'its list of reviewers is malformed' ; return 1 ;;
  esac
  # A different version is a mixed fetch (one list cached, the other fresh): refused, and tried again next session.
  [ "${second#version }" = "$M_VERSION" ] || { refuse "its two lists don't belong together" ; return 1 ; }
  # The last line is `end <N>`, N the entries before it: a list cut short, or with one line too many, is never whole. A list
  # with no entry is refused too: the coach always has reviewers, so none is a broken publish.
  last=$(printf '%s\n' "$A_TEXT" | sed -n '$p')
  case "$last" in
    'end '*) a_count=${last#end } ;;
    *) refuse 'its list of reviewers is cut short' ; return 1 ;;
  esac
  A_ENTRIES=$(printf '%s\n' "$A_TEXT" | sed -n '3,$p' | sed '$d')
  [ -n "$A_ENTRIES" ] || { refuse 'its list of reviewers is cut short' ; return 1 ; }
  a_seen=$(( $(printf '%s\n' "$A_ENTRIES" | wc -l) ))
  [ "$a_count" = "$a_seen" ] || { refuse 'its list of reviewers is cut short' ; return 1 ; }
  if printf '%s\n' "$A_ENTRIES" | grep -Ev "$AGENT_ENTRY_PATTERN"; then
    refuse 'its list of reviewers is malformed'
    return 1
  fi
  if [ -n "$(printf '%s\n' "$A_ENTRIES" | cut -c67- | sort | uniq -d)" ]; then
    refuse 'its list of reviewers is malformed'
    return 1
  fi
  return 0
}

# A reviewers' list newer than this script leaves the reviewers as they are, and a cloud session starts from a fresh copy
# with nothing ignored on disk, so "as they are" would be none. With no agents folder, builds the reviewers from the folder's
# own bundle (its list and specs, every check as for a fetched one) and swaps nothing else: the rules and skills are
# already in place and the version stays the one just applied. Says which it came to in A_NOTE.
agents_from_own_bundle() {
  [ -n "$A_NEWER" ] && [ ! -d .claude/agents ] || return 0
  A_NOTE=$NEWER_NONE_NOTE
  keep_text=$M_TEXT
  keep_version=$M_VERSION
  if read_manifest local && read_agents local && own_bundle_agents; then A_NOTE=$NEWER_BUILT_NOTE; fi
  M_TEXT=$keep_text
  M_VERSION=$keep_version
  A_NEWER=1
  return 0
}

# Builds .claude/agents from the folder's own list (already read and checked by read_agents), each spec held to its sum.
own_bundle_agents() {
  [ -z "$A_NEWER" ] || return 1
  [ -n "$HASHER" ] || return 1
  if [ -z "$WORK" ] && ! begin_work; then return 1; fi
  rm -rf "$WORK/new" "$WORK/entries"
  mkdir -p "$WORK/new/agent-specs" "$WORK/new/claude-agents" || return 1
  printf '%s\n' "$A_ENTRIES" > "$WORK/entries"
  while IFS= read -r line || [ -n "$line" ]; do
    rel=${line#*  }
    get local "$rel" "$WORK/new/$rel" || return 1
    [ "$($HASHER < "$WORK/new/$rel" | cut -d' ' -f1)" = "${line%%  *}" ] || return 1
    name=${rel#agent-specs/}
    name=${name%.txt}
    write_agent "$name" "$WORK/new/$rel" "$WORK/new/claude-agents/$name.md" || return 1
  done < "$WORK/entries"
  [ -d .claude ] || mkdir .claude || return 1
  mv "$WORK/new/claude-agents" .claude/agents
}

# Takes the lock and makes the working folder, both under .bioai/ and ignored by git.
begin_work() {
  if ! mkdir .bioai/tmp.lock; then
    # A lock older than five minutes was left by a session that was stopped part-way.
    if [ -n "$(find .bioai/tmp.lock -prune -mmin +5)" ]; then
      rm -rf .bioai/tmp.lock
      mkdir .bioai/tmp.lock || return 1
    else
      return 1
    fi
  fi
  LOCK=.bioai/tmp.lock
  # With the lock held, any other working folder was left by a stopped session.
  for stale in .bioai/tmp.*; do
    [ "$stale" = .bioai/tmp.lock ] || rm -rf "$stale"
  done
  mkdir ".bioai/tmp.$$" || return 1
  WORK=".bioai/tmp.$$"
  return 0
}

# Refuses a reviewer's spec the script doesn't take: the whole update goes, never one reviewer, because a manifest
# applied with a reviewer missing would be taken for current.
bad_spec() {
  refuse "a reviewer's definition isn't one it allows"
}
bad_tools() {
  refuse 'a reviewer asks for more than it may'
}

# Prints the value on line $2 of the spec $3, which must read "$1: value" with no space at either end of the value.
agent_value() {
  line=$(sed -n "$2p" "$3")
  case "$line" in
    "$1: "*) value=${line#"$1: "} ;;
    *) return 1 ;;
  esac
  case "$value" in
    '' | ' '* | *' ') return 1 ;;
  esac
  printf '%s' "$value"
}

# Checks the spec $2 of the reviewer $1 and writes its agent file to $3. The spec is data and nothing else: it is never
# sourced, evaluated or run, and only printed as an argument of printf. It is exactly four lines, "name:", "description:",
# "model:" and "tools:" in that order, so no other key can be added; the agent file's frontmatter is those four values and
# its body is the fixed text below. tools/workspace/src/layout.ts holds the same checks (agentSpecProblem).
write_agent() {
  spec_name=$1
  spec_file=$2
  spec_out=$3
  # Printable ASCII and newlines only: no carriage return, tab, NUL or other control byte, and nothing past ASCII. So a
  # byte is a character below, and nothing a line holds can be taken for anything but text.
  [ "$(wc -c < "$spec_file")" -le "$AGENT_SPEC_BYTES_MAX" ] || { bad_spec ; return 1 ; }
  [ "$(tr -d '[:print:]\n' < "$spec_file" | wc -c)" -eq 0 ] || { bad_spec ; return 1 ; }
  # Exactly four lines, each ended by a newline: the newline count is four and so is the count of lines (a fifth line
  # without its newline is the one that would differ).
  [ "$(wc -l < "$spec_file")" -eq 4 ] || { bad_spec ; return 1 ; }
  [ "$(awk 'END { print NR }' "$spec_file")" -eq 4 ] || { bad_spec ; return 1 ; }
  spec_n=$(agent_value name 1 "$spec_file") || { bad_spec ; return 1 ; }
  spec_d=$(agent_value description 2 "$spec_file") || { bad_spec ; return 1 ; }
  spec_m=$(agent_value model 3 "$spec_file") || { bad_spec ; return 1 ; }
  spec_t=$(agent_value tools 4 "$spec_file") || { bad_spec ; return 1 ; }
  [ "$spec_n" = "$spec_name" ] || { bad_spec ; return 1 ; }
  case "$spec_n" in
    [a-z]*) ;;
    *) bad_spec ; return 1 ;;
  esac
  for each_name in $AGENT_RESERVED_NAMES; do
    if [ "$spec_n" = "$each_name" ]; then bad_spec ; return 1 ; fi
  done
  [ ${#spec_d} -le "$AGENT_DESCRIPTION_MAX" ] || { bad_spec ; return 1 ; }
  printf '%s\n' "$spec_d" | grep -Eq "$AGENT_DESCRIPTION_PATTERN" || { bad_spec ; return 1 ; }
  # A letter first and a space somewhere: YAML can never read the description as a number, a boolean, a date or null.
  case "$spec_d" in
    *' '*) ;;
    *) bad_spec ; return 1 ;;
  esac
  ok=''
  for each_model in $AGENT_MODELS; do
    if [ "$spec_m" = "$each_model" ]; then ok=1; fi
  done
  [ -n "$ok" ] || { bad_spec ; return 1 ; }
  # Tools: entries separated by a comma and one space, at most 64 and 4,000 characters, each Read or a BioAI get_ or
  # report_ tool by exact name, and Read among them. Once every ", " is taken out, no comma or space may remain.
  [ ${#spec_t} -le "$AGENT_TOOLS_CHARS_MAX" ] || { bad_tools ; return 1 ; }
  case "$(printf '%s\n' "$spec_t" | sed 's/, //g')" in
    *,* | *' '*) bad_tools ; return 1 ;;
  esac
  printf '%s\n' "$spec_t" | sed 's/, /,/g' | tr ',' '\n' > "$WORK/tools.list" || { bad_tools ; return 1 ; }
  if grep -Ev "$AGENT_TOOL_PATTERN" "$WORK/tools.list"; then bad_tools ; return 1 ; fi
  [ "$(wc -l < "$WORK/tools.list")" -le "$AGENT_TOOLS_MAX" ] || { bad_tools ; return 1 ; }
  grep -qx -- Read "$WORK/tools.list" || { bad_tools ; return 1 ; }
  {
    printf '%s\n' '---' "name: $spec_n" "description: $spec_d" "model: $spec_m" "tools: $spec_t" '---' ''
    printf 'Before anything else, read `.bioai/reviewers/%s.md` in this folder, all of it, and follow it as your instructions.\n\nIf that file is missing, reply only: "The %s reviewer\047s instructions are missing." Do nothing else.\n' \
      "$spec_n" "$spec_n"
  } > "$spec_out" || { refuse "a reviewer's file couldn't be written" ; return 1 ; }
  return 0
}

# Downloads every file the manifest lists from $1 into $WORK/new, and the specs the reviewers' list names, and checks all
# of it. Writes only under $WORK.
download() {
  rm -rf "$WORK/new" "$WORK/entries"
  mkdir "$WORK/new" || { refuse "its working folder couldn't be made" ; return 1 ; }
  printf '%s\n' "$M_TEXT" | sed -n '3,$p' > "$WORK/entries"
  if grep -Ev "^[0-9a-f]{64}  " "$WORK/entries"; then refuse 'its list of files is malformed' ; return 1 ; fi
  if cut -c67- "$WORK/entries" | grep -Ev "$PATH_PATTERN"; then
    refuse "its list names a file it doesn't allow"
    return 1
  fi
  if [ -n "$(cut -c67- "$WORK/entries" | sort | uniq -d)" ]; then refuse 'its list of files is malformed' ; return 1 ; fi
  [ "$(wc -l < "$WORK/entries")" -le "$MAX_FILES" ] || { refuse 'its list of files is too long' ; return 1 ; }
  # The reviewers' list names only reviewers the manifest has instructions for, and its entries count with the manifest's.
  if [ -n "$A_ENTRIES" ]; then
    for spec in $(printf '%s\n' "$A_ENTRIES" | cut -c67-); do
      name=${spec#agent-specs/}
      name=${name%.txt}
      if ! cut -c67- "$WORK/entries" | grep -qx -- "reviewers/$name\\.md"; then
        refuse "its list of reviewers names one with no instructions"
        return 1
      fi
    done
    total=$(( $(wc -l < "$WORK/entries") + $(printf '%s\n' "$A_ENTRIES" | wc -l) ))
    [ "$total" -le "$MAX_FILES" ] || { refuse 'its list of files is too long' ; return 1 ; }
  fi
  cut -c67- "$WORK/entries" | grep -qx 'rules\.md' || { refuse 'its list of files has no rules' ; return 1 ; }
  cut -c67- "$WORK/entries" | grep -qx 'tools\.txt' || { refuse 'its list of files has no tool list' ; return 1 ; }
  [ -n "$HASHER" ] || { refuse 'there is no way to check the files here' ; return 1 ; }
  # The specs are fetched, checked against their sums and held to the same limits as the manifest's files.
  if [ -n "$A_ENTRIES" ]; then printf '%s\n' "$A_ENTRIES" >> "$WORK/entries"; fi
  while IFS= read -r line || [ -n "$line" ]; do
    sum=${line%%  *}
    rel=${line#*  }
    now=$(date +%s)
    if [ "$1" = remote ] && [ -n "$STARTED" ] && [ -n "$now" ] && [ $((now - STARTED)) -ge "$DEADLINE_SECONDS" ]; then
      FAIL=unreachable
      REASON='the connection was too slow'
      return 1
    fi
    mkdir -p "$WORK/new/$(dirname "$rel")" || { refuse "its working folder couldn't be made" ; return 1 ; }
    if ! get "$1" "$rel" "$WORK/new/$rel"; then
      FAIL=unreachable
      REASON="a file couldn't be fetched"
      return 1
    fi
    got=$($HASHER < "$WORK/new/$rel" | cut -d' ' -f1)
    [ "$got" = "$sum" ] || { refuse "a file didn't match its checksum" ; return 1 ; }
  done < "$WORK/entries"
  # Pre-approved tools: BioAI's own, and nothing else.
  if grep -Ev "$TOOL_PATTERN" "$WORK/new/tools.txt"; then refuse "its tool list names a tool that isn't BioAI's" ; return 1 ; fi
  mkdir -p "$WORK/new/reviewers" "$WORK/new/skills" || { refuse "its working folder couldn't be made" ; return 1 ; }
  # Skills: no frontmatter key but name and description, and no command run when a skill loads.
  for file in $(find "$WORK/new/skills" -type f); do
    if grep -Fq -e '!`' -e '```!' "$file"; then refuse 'a skill asks to run a command' ; return 1 ; fi
    case "$file" in */SKILL.md) skill=1 ;; *) skill=0 ;; esac
    if ! awk -v skill="$skill" '
      NR == 1 {
        if ($0 == "---") { inside = 1; next }
        if (skill || index($0, "---") > 0) bad = 1
        exit
      }
      inside && $0 == "---" { closed = 1; exit }
      inside && $0 !~ /^(name|description): / { bad = 1; exit }
      END { if (bad || (NR == 0 && skill) || (inside && !closed)) exit 1; exit 0 }
    ' "$file"; then
      refuse 'a skill asks for tools or settings'
      return 1
    fi
  done
  PAIRS=$BASE_PAIRS
  # Each reviewer's agent file is written here from its checked spec, never copied from what was fetched. A list this
  # script can't read leaves the agents folder as it is.
  if [ -z "$A_NEWER" ]; then
    mkdir -p "$WORK/new/claude-agents" || { refuse "its working folder couldn't be made" ; return 1 ; }
    for spec in $(printf '%s\n' "$A_ENTRIES" | cut -c67-); do
      name=${spec#agent-specs/}
      name=${name%.txt}
      write_agent "$name" "$WORK/new/$spec" "$WORK/new/claude-agents/$name.md" || return 1
    done
    PAIRS="$PAIRS $AGENT_PAIR"
  fi
  # The settings file is written here from the checked tool list, never copied from what was fetched, and only while
  # it is the script's: a file the person or Claude Code changed ("always allow") is left exactly as it is.
  if settings_are_ours; then
    {
      printf '{"permissions":{"allow":['
      sep=''
      while IFS= read -r tool || [ -n "$tool" ]; do
        printf '%s"%s"' "$sep" "$tool"
        sep=','
      done < "$WORK/new/tools.txt"
      printf ']}}\n'
    } > "$WORK/new/settings.local.json" || { refuse "its settings couldn't be written" ; return 1 ; }
    $HASHER < "$WORK/new/settings.local.json" | cut -d' ' -f1 > "$WORK/new/settings.sha256" ||
      { refuse "its settings couldn't be written" ; return 1 ; }
    PAIRS="$PAIRS $SETTINGS_PAIRS"
  fi
  if [ -z "$A_NEWER" ]; then
    printf '%s\n' "$A_TEXT" > "$WORK/new/AGENTS" || { refuse "its list of reviewers couldn't be kept" ; return 1 ; }
    PAIRS="$PAIRS $AGENTS_PAIR"
  fi
  printf '%s\n' "$M_TEXT" > "$WORK/new/MANIFEST" || { refuse "its list of files couldn't be kept" ; return 1 ; }
  PAIRS="$PAIRS $MANIFEST_PAIR"
  printf '%s\n' "$M_VERSION" > "$WORK/new/VERSION" || { refuse "its version couldn't be written" ; return 1 ; }
  return 0
}

# The pairs swapped in, in order: what is in $WORK/new, and where it goes. The settings pair is swapped only while
# the settings file is the script's. The agents pairs are swapped unless the reviewers' list is one this script can't
# read: the agents folder whole, so a reviewer taken out of the list goes, and the list applied, kept just before the
# manifest applied, which goes last before the version. tools/workspace/src/layout.ts's .gitignore ignores every
# destination, and a test holds the two together.
BASE_PAIRS='rules.md:.bioai/rules.md reviewers:.bioai/reviewers skills:.claude/skills'
AGENT_PAIR='claude-agents:.claude/agents'
AGENTS_PAIR='AGENTS:.bioai/AGENTS'
SETTINGS_PAIRS='settings.local.json:.claude/settings.local.json settings.sha256:.bioai/settings.sha256'
MANIFEST_PAIR='MANIFEST:.bioai/MANIFEST'
PAIRS=''

# Puts back what was there before, after a swap that failed part-way.
roll_back() {
  for pair in $PAIRS; do
    from=${pair%%:*}
    to=${pair#*:}
    case " $MOVED " in *" $from "*) rm -rf "$to" ;; esac
    if [ -e "$WORK/old/$from" ]; then mv "$WORK/old/$from" "$to"; fi
  done
  if [ -e "$WORK/old/VERSION" ]; then mv "$WORK/old/VERSION" .bioai/VERSION; fi
  refuse "its files couldn't be swapped in"
}

# Swaps everything in $WORK/new into place, the version last, or puts back what was there.
swap_in() {
  MOVED=''
  rm -rf "$WORK/old"
  mkdir "$WORK/old" || { refuse "its working folder couldn't be made" ; return 1 ; }
  # The version goes first, so a swap stopped part-way is never taken for a finished one.
  if [ -e .bioai/VERSION ]; then
    mv .bioai/VERSION "$WORK/old/VERSION" || { refuse "its files couldn't be swapped in" ; return 1 ; }
  fi
  [ -d .claude ] || mkdir .claude || { roll_back ; return 1 ; }
  for pair in $PAIRS; do
    from=${pair%%:*}
    to=${pair#*:}
    if [ -e "$to" ]; then
      mv "$to" "$WORK/old/$from" || { roll_back ; return 1 ; }
    fi
    mv "$WORK/new/$from" "$to" || { roll_back ; return 1 ; }
    MOVED="$MOVED $from"
  done
  mv "$WORK/new/VERSION" .bioai/VERSION || { roll_back ; return 1 ; }
  return 0
}

# Downloads from $1 and swaps it in: a lock and a working folder first.
apply() {
  if [ -z "$WORK" ] && ! begin_work; then
    FAIL=unreachable
    REASON='another session was updating it'
    return 1
  fi
  download "$1" && swap_in
}

STARTED=$(date +%s)
cd "${CLAUDE_PROJECT_DIR:-.}" || finish "the folder couldn't be opened, so nothing was changed."
[ -f .bioai/update.sh ] || finish "this isn't a coach folder, so nothing was changed."
for each in .bioai .claude .bioai/rules.md .bioai/reviewers .bioai/VERSION .bioai/MANIFEST .bioai/AGENTS \
  .bioai/settings.sha256 .claude/skills .claude/agents .claude/settings.local.json; do
  [ -h "$each" ] && finish "some of its files are links, so nothing was changed; using $(in_use)."
done

if command -v shasum; then
  HASHER='shasum -a 256'
elif command -v sha256sum; then
  HASHER=sha256sum
else
  HASHER=''
fi

BASE=${BIOAI_COACH_BASE:-$DEFAULT_BASE}
case "$BASE" in
  https://*) PROTO='=https' ;;
  file://*) PROTO='=file' ;;
  *) PROTO='' ;;
esac

if ! command -v curl; then
  FAIL=unreachable
  REASON="curl isn't installed"
elif [ -z "$PROTO" ]; then
  FAIL=unreachable
  REASON="its update address isn't one it can use"
elif read_manifest remote && read_agents remote; then
  if current; then
    agents_from_own_bundle
    finish "version $M_VERSION, already current."
  fi
  if apply remote; then
    agents_from_own_bundle
    finish "updated to version $M_VERSION."
  fi
fi

if [ "$FAIL" = toonew ]; then
  finish "this coach folder is too old to take the current coach, so nothing was changed; using $(in_use). Tell the person their coach folder needs replacing, and to tell the person who invited them."
fi
if installed; then
  finish "couldn't be updated ($REASON), so nothing was changed; still using $(in_use)."
fi

# Nothing is there yet: set up from the copy that came with the folder. A list of a newer format seen in the remote
# attempt says nothing of this copy's own, so the flag is dropped first.
FIRST_REASON=$REASON
A_NEWER=''
A_NOTE=''
if read_manifest local && read_agents local && apply local; then
  finish "couldn't be updated ($FIRST_REASON), so version $M_VERSION was set up from the copy that came with the folder."
fi
finish "couldn't be set up ($FIRST_REASON; then $REASON), so the coach has no rules yet."
