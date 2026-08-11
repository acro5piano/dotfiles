# cc-sessions: browse Claude Code sessions across ALL project directories
# and resume the picked one (cd into its cwd, then `claude --resume <id>`).
#
# Claude Code stores history per working directory under ~/.claude/projects/,
# so `claude --resume` only ever shows the current folder. This merges them all.

function __cc_index -d 'Emit tab-separated session rows, newest first'
    set -l dir ~/.claude/projects
    test -d $dir; or return

    # epoch<TAB>path in one pass, skip subagent transcripts, newest first
    find $dir -type f -name '*.jsonl' -not -name 'agent-*' -printf '%T@\t%p\n' \
        | sort -rn \
        | while read -l ln
        set -l epoch (string split -m1 . (string split -m1 \t $ln)[1])[1]
        set -l f (string split -m1 \t $ln)[2]
        test -s "$f"; or continue

        # Pull the session's cwd and first *real* user prompt in a single read.
        set -l cm (jq -rc '
            ( if .cwd then "CWD\t"+.cwd else empty end ),
            ( if (.type=="user" and (.message.role=="user")) then
                "MSG\t"+((.message.content
                    | if type=="string" then . else (map(select(.type=="text").text)|join(" ")) end)
                    | gsub("[\n\t]";" "))
              else empty end )
        ' "$f" 2>/dev/null | awk -F'\t' '
            $1=="CWD" && !c {c=$2}
            $1=="MSG" && $2 !~ /^ *$|^<command|^<local-command|^<system-reminder|^Caveat:|^\[Request interrupted|^Base directory for this skill|tool_use_id/ && !m {m=$2}
            c && m {print c"\t"m; exit}
            END{ if(!m) print c"\t(no prompt)" }
        ')

        set -l cwd (string split -m1 \t $cm)[1]
        set -l msg (string split -m1 \t $cm)[2]
        test -n "$cwd"; or set cwd (dirname "$f")
        set -l sid (string replace -r '\.jsonl$' '' (basename "$f"))
        set -l dt (date -d "@$epoch" '+%Y-%m-%d %H:%M')
        set -l proj (basename "$cwd")

        # fields: date  project  message  |  sid  cwd  file
        printf '%s\t%-22.22s\t%.120s\t%s\t%s\t%s\n' "$dt" "$proj" "$msg" "$sid" "$cwd" "$f"
    end
end

function __cc_preview -d 'Render a session transcript for fzf preview'
    set -l f $argv[1]
    test -f "$f"; or return
    set -l cols $FZF_PREVIEW_COLUMNS
    test -n "$cols"; or set cols 100
    jq -rc '
        select(.type=="user" or .type=="assistant")
        | (.message.role) as $r
        | ((.message.content) | if type=="string" then . else (map(select(.type=="text").text)|join("\n")) end) as $t
        | select($t|type=="string" and test("[^ \t\r\n]"))
        | select($t|test("^<command|^<local-command|^<system-reminder|tool_use_id|^Base directory for this skill")|not)
        | (if $r=="user" then "▶ user" else "● assistant" end) + "\n" + $t + "\n"
    ' "$f" 2>/dev/null \
        | awk -v u=(set_color -o cyan) -v a=(set_color -o green) -v n=(set_color normal) '
            /^\xe2\x96\xb6 user$/      {print u $0 n; next}
            /^\xe2\x97\x8f assistant$/ {print a $0 n; next}
            {print}
        ' \
        | fold -s -w $cols \
        | head -600
end

function cc-sessions -d 'Fuzzy-pick a Claude Code session from any directory and resume it'
    if not type -q jq; or not type -q fzf
        echo 'cc-sessions needs `jq` and `fzf`.' >&2
        return 1
    end

    set -l sel (__cc_index | fzf \
        --delimiter \t \
        --with-nth 1,2,3 \
        --no-hscroll \
        --header 'enter: resume  ·  ctrl-y: copy session id  ·  ctrl-o: cd only' \
        --expect ctrl-o \
        --preview '__cc_preview {6}' \
        --preview-window 'right,55%,wrap' \
        --bind 'ctrl-y:execute-silent(printf %s {4} | wl-copy)')

    test -z "$sel"; and return

    # First line is the pressed --expect key (empty on plain Enter)
    set -l key $sel[1]
    set -l row $sel[2]
    test -z "$row"; and set row $sel[1]; and set key ''

    set -l parts (string split \t $row)
    set -l sid $parts[4]
    set -l cwd $parts[5]

    if not test -d "$cwd"
        echo "Directory no longer exists: $cwd" >&2
        echo "Session id: $sid" >&2
        return 1
    end

    cd "$cwd"
    commandline -f repaint
    if test "$key" = ctrl-o
        echo "cd $cwd  (session $sid)"
        return
    end
    claude --resume "$sid"
end

# short alias
function ccs -w cc-sessions -d 'alias for cc-sessions'
    cc-sessions $argv
end
