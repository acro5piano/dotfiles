# vim:set ft=bash

set git_dirty_color red
set git_clean_color green

function parse_git_branch
    git rev-parse --git-dir >/dev/null ^&1; or return

    set -l current_branch (git branch --contains=HEAD | grep '^*' | awk '{print $2}')
    set -l git_changed_files_count (git status -s -uall | wc -l)

    if [ "$git_changed_files_count" -eq 0 ]
        echo (set_color $git_clean_color)$current_branch(set_color normal)
    else
        echo (set_color $git_dirty_color)$current_branch(set_color normal)
    end
end

function fish_prompt -d 'Write out the prompt'
    if [ $status -eq 0 ]
        set status_face (set_color green)"(*'-')"
    else
        set status_face (set_color red)"(*>_<)"
    end

    echo -e $status_face \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) \
        [(parse_git_branch)] \
        (date +%Y-%m-%d.%H:%M:%S) \
        "\n~> "
end
