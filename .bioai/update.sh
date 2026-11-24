#!/bin/sh
# The BioAI coach folder's start-up script. Claude Code runs it at the start of every session (the SessionStart hook in
# .claude/settings.json). It fetches the current coach file by file from the public repository's bundle/ folder, checks
# all of it, and swaps it in: .bioai/rules.md, .bioai/reviewers/, .claude/skills/, .claude/settings.local.json (only
# while it is the one the script wrote, by the sum in .bioai/settings.sha256), .bioai/MANIFEST (the manifest applied),
# and .bioai/VERSION last. It writes nothing else and nowhere else, git ignores all of it, and it always exits 0, so a
# session always starts. The repository can change what the coach is told. It can't change this script, and it can't
# pre-approve anything but BioAI's own tools.
#
# POSIX sh only (macOS and Linux). Its source is tools/workspace/src/update.sh in the platform repository, copied in by
# `pnpm workspace:publish`; it is part of the folder's fixed files and never refreshes itself.

FORMAT_SUPPORTED=1
DEFAULT_BASE=https://raw.githubusercontent.com/brandallux-bit/sync-proof-delete-me/source/bundle
READ_LINE='Read .bioai/rules.md now, all of it, before you reply.'
MAX_FILES=400
DEADLINE_SECONDS=45

# The allow-lists. tools/workspace/src/layout.ts holds the same patterns, and a test holds the two together.
PATH_PATTERN='^(rules\.md|tools\.txt|skills/[a-z0-9-]+/[A-Za-z0-9_-][A-Za-z0-9._-]*|reviewers/[a-z0-9-]+\.md)$'
TOOL_PATTERN='^mcp__claude_ai_BioAI__[a-z0-9_]+$'
VERSION_CHARS='A-Za-z0-9._-'

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

cleanup() {
  if [ -n "$WORK" ]; then rm -rf "$WORK"; WORK=''; fi
  if [ -n "$LOCK" ]; then rmdir "$LOCK"; LOCK=''; fi
}
trap cleanup EXIT
trap 'exit 0' HUP INT TERM

# Prints the message and the read instruction, and ends the script.
finish() {
  cleanup
  printf 'BioAI coach folder: %s\n%s\n' "$1" "$READ_LINE" >&3
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
# Code has changed it, it is theirs.
installed() {
  [ -f .bioai/rules.md ] && [ -d .bioai/reviewers ] && [ -d .claude/skills ] && [ -n "$(current_version)" ]
}

# The manifest applied last time is byte for byte the one just read, and everything is there: nothing to do.
current() {
  installed && [ -f .bioai/MANIFEST ] && [ "$(cat .bioai/MANIFEST)" = "$M_TEXT" ]
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

# Downloads every file the manifest lists from $1 into $WORK/new, and checks all of it. Writes only under $WORK.
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
  cut -c67- "$WORK/entries" | grep -qx 'rules\.md' || { refuse 'its list of files has no rules' ; return 1 ; }
  cut -c67- "$WORK/entries" | grep -qx 'tools\.txt' || { refuse 'its list of files has no tool list' ; return 1 ; }
  [ -n "$HASHER" ] || { refuse 'there is no way to check the files here' ; return 1 ; }
  started=$(date +%s)
  while IFS= read -r line || [ -n "$line" ]; do
    sum=${line%%  *}
    rel=${line#*  }
    now=$(date +%s)
    if [ -n "$started" ] && [ -n "$now" ] && [ $((now - started)) -ge "$DEADLINE_SECONDS" ]; then
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
  printf '%s\n' "$M_TEXT" > "$WORK/new/MANIFEST" || { refuse "its list of files couldn't be kept" ; return 1 ; }
  PAIRS="$PAIRS $MANIFEST_PAIR"
  printf '%s\n' "$M_VERSION" > "$WORK/new/VERSION" || { refuse "its version couldn't be written" ; return 1 ; }
  return 0
}

# The pairs swapped in, in order: what is in $WORK/new, and where it goes. The settings pair is swapped only while
# the settings file is the script's; the manifest applied goes last before the version. tools/workspace/src/layout.ts's
# .gitignore ignores every destination, and a test holds the two together.
BASE_PAIRS='rules.md:.bioai/rules.md reviewers:.bioai/reviewers skills:.claude/skills'
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

cd "${CLAUDE_PROJECT_DIR:-.}" || finish "the folder couldn't be opened, so nothing was changed."
[ -f .bioai/update.sh ] || finish "this isn't a coach folder, so nothing was changed."
for each in .bioai .claude .bioai/rules.md .bioai/reviewers .bioai/VERSION .bioai/MANIFEST .bioai/settings.sha256 \
  .claude/skills .claude/settings.local.json; do
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
elif read_manifest remote; then
  if current; then
    finish "version $M_VERSION, already current."
  fi
  if apply remote; then
    finish "updated to version $M_VERSION."
  fi
fi

if [ "$FAIL" = toonew ]; then
  finish "this coach folder is too old to take the current coach, so nothing was changed; using $(in_use). Tell the person their coach folder needs replacing, and to tell the person who invited them."
fi
if installed; then
  finish "couldn't be updated ($REASON), so nothing was changed; still using $(in_use)."
fi

# Nothing is there yet: set up from the copy that came with the folder.
FIRST_REASON=$REASON
if read_manifest local && apply local; then
  finish "couldn't be updated ($FIRST_REASON), so version $M_VERSION was set up from the copy that came with the folder."
fi
finish "couldn't be set up ($FIRST_REASON; then $REASON), so the coach has no rules yet."
