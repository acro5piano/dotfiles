set -gx ANDROID_HOME /opt/android-sdk
set -gx ANDROID_SDK_ROOT /opt/android-sdk

function has
    which $1 >/dev/null 2>/dev/null
end

set -gx GOPATH $HOME/go
set -gx PATH \
            $ANDROID_HOME/tools/bin \
            $DENO_INSTALL/bin \
            /usr/local/opt/php@7.4/bin \
            $HOME/.local/bin \
            $HOME/bin \
            $ANDROID_HOME/tools \
            $ANDROID_HOME/platform-tools \
            $HOME/.cargo/bin \
            $HOME/.pulumi/bin \
            $HOME/go/bin \
            $PATH ^/dev/null
set -gx EDITOR nvim
set -gx VISUAL nvim

set -gx PIPENV_VENV_IN_PROJECT 1

set -gx CLOUDSDK_PYTHON /usr/bin/python3.12

set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx LC_CTYPE en_US.UTF-8

set -gx PYTHON_KEYRING_BACKEND keyring.backends.null.Keyring

set -gx BROWSER brave

function seishin
    set dir ~/sandbox/(date +%Y%m%d_%H%M%S)
    mkdir -p $dir
    cd $dir
end

function gl
  if [ "$argv" ]
    set domain github.com
    if echo "$argv" | grep -q :
        set domain (echo "$argv" | perl -pe 's/^(.+):.+$/\1/')
    end
    set repo (echo "$argv" | perl -pe 's/^.+:(.+)$/\1/')
    set dir (echo ~/ghq/$domain/$repo)
    git clone git@$domain:$repo ~/ghq/$domain/$repo
    cd ~/ghq/$domain/$repo
  else
    find ~/ghq/ -maxdepth 3 | grep -E '/.+/.+/.+/.+/.+/.+' | grep -v DS_Store | fzf-tmux -h --no-preview -p 60%,60% | read line
    if [ $line ]
      cd $line
      commandline -f repaint
    end
  end
end

function g
  if [ "$argv" ]
    git $argv
  else
    git status -uall
  end
end
complete --command g --wraps git

function gup
  echo $PWD
  if [ $PWD = '/' ]
    return 1
  else if ls -a | grep -q '^.git$'
    return 0
  else
    cd ..
    gup
  end
end

function mozc
    switch $argv
    case 'dict'
        /usr/lib/mozc/mozc_tool --mode=dictionary_tool
    case 'word'
        /usr/lib/mozc/mozc_tool --mode=word_register_dialog
    case 'config'
        /usr/lib/mozc/mozc_tool --mode=config_dialog
    case '*'
        echo 'mozc [dict|word|config]'
    end
end

# TODO: divide files to os specific file
function cl
		cat /dev/stdin | perl -pe 'chomp if eof' | wl-copy
end
function clp
		wl-paste
end

function grep-replace
    git ls-files -z | xargs -0 perl -i -pe "s#$argv[1]#$argv[2]#g"
end

function sub
    perl -pe "s#$argv[1]#$argv[2]#"
end

function gsub
    perl -pe "s#$argv[1]#$argv[2]#g"
end

function snakecase
    perl -pe 's#([A-Z])#_\L$1#g' | perl -pe 's#^_##'
end

function camelcase
    perl -pe 's#(_|^)(.)#\u$2#g'
end

function titlecase
    /bin/ruby -nale 'puts $_.gsub(/([A-Z])/, \'_\1\').gsub(/^_/, \'\').upcase'
    # '''
end

function insert
    perl -pe "s#^#$argv[1] #g"
end

function append
    perl -pe "s#\$# $argv[1]#"
end

function delete
    perl -pe "s#$argv[1]##g"
end

function gacp
    git commit -am "$argv" && git ps
end

function tmsp
    tmux swap-window -t $argv[1]
end

function clear-branches
    echo 'removing:'
    git branch | grep -v \* | grep -v master | grep -v main | grep -v develop | perl -pe 's/^/  /'
    echo
    read res -n1 -P 'Continue? [Y/n]'
    if [ res != 'Y' ]
        return
    end
    git branch | grep -v \* | grep -v master | grep -v main | grep -v develop |  xargs git branch -D
end

# }}}

function fish_user_key_bindings
    bind \e\ch backward-kill-word
    bind \ew __copy_command
end
function __copy_command
  echo -n (commandline -b) | cl
end

function parse_git_branch
    git status >/dev/null 2>/dev/null || return

    set -l current_branch (git branch --contains=HEAD | grep '^*' | awk '{print $2}')
    set -l git_changed_files_count (git status -s -uall | wc -l)

    if [ "$git_changed_files_count" -eq 0 ]
        echo (set_color green)$current_branch(set_color normal)
    else
        echo (set_color red)$current_branch(set_color normal)
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

# {{{ aliases

alias ..='cd ..'
alias ,d='cd ~/.dotfiles; nvim'

alias c='chatgpt'

alias ag='rg'
alias dc='docker-compose'
alias grep='grep --color=auto'
alias gd='tmux-zoom && git diff HEAD && tmux resize-pane -Z'
alias less='less -R'
alias justnow='date +%Y%m%d_%H%M%S'
alias tree='tree --charset XXX -I .git -I vendor -I node_modules'
alias t='toggl'
alias decode-jwt='jq -R \'split(".") | .[1] | @base64d | fromjson\'' # '

alias rg="rg --hidden --glob '!.git'"
alias ghrw="watch -n 5 gh run list"

alias v="vim"
alias nv="nvim"

alias sum='perl -nale \'$sum += $_; END { print $sum }\''
alias avg='perl -nale \'$sum += $_; END { print $sum / $.}\'' # '

alias csv='column -ts ,'
alias tsv='column -ts \t'

alias restart-xremap="killall xremap && nohup xremap ~/.xremap 2>&1 > /tmp/xremap.log &"
alias feh="feh --scale-down --offset +0+0"
alias pn="pnpm"

set TTY (tty)

# Run tmux if not running
if string match -q '/dev/pts/*' "$TTY"
	if ! tmux list-sessions | grep -q ''
		tmux
	end
end

if [ "$TTY" = "/dev/tty1" ]
    XDG_CURRENT_DESKTOP=sway sway
end

# The next line updates PATH for the Google Cloud SDK.
# Comment out temporary for it slows down startup time
# if [ -f ~/var/google-cloud-sdk/path.fish.inc ]; . ~/var/google-cloud-sdk/path.fish.inc; end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# pnpm
set -gx PNPM_HOME "/home/kazuya/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

fnm env --use-on-cd | source > /dev/null
