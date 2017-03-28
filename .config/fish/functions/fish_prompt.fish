# vim:set ft=bash

set git_dirty_color red
set git_not_dirty_color green

function parse_git_branch
    set -l git_dir (git rev-parse --git-dir 2> /dev/null)
    [ $status -ne 0 ]; and return

    set -l branch (git branch --contains=HEAD | awk '{print $2}')
    set -l git_diff (git diff)

    if test -n "$git_diff"
        echo (set_color $git_dirty_color)$branch(set_color normal)
    else
        echo (set_color $git_not_dirty_color)$branch(set_color normal)
    end
end

function fish_prompt -d 'Write out the prompt'
    if [ $status -eq 0 ]
        set status_face (set_color green)"(*'-')"
    else
        set status_face (set_color red)"(*T_T)"
    end

    echo -e $status_face \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) \
        [(parse_git_branch)] \
        (date +%Y-%m-%d.%H:%M:%S) \
        "\n ~> "
end
