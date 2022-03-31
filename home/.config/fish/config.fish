# vim:set ft=sh :

# {{{ Env vars

if [ -e /Applications ]
    set -gx IS_MAC 1
else
    set -gx IS_MAC 0
end

set -gx ANDROID_HOME /opt/android-sdk
set -gx ANDROID_SDK_ROOT /opt/android-sdk

if [ -e $HOME/Library/Android ]
    set -gx JAVA_HOME (/usr/libexec/java_home)
    set -gx STUDIO_JDK /Library/Java/JavaVirtualMachines/jdk-10.jdk
    set -gx ANDROID_HOME $HOME/Library/Android/sdk
end

set -gx DENO_INSTALL $HOME/.deno

set -gx PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

set -gx GTK_IM_MODULE fcitx

[ -e $HOME/go ]; or mkdir $HOME/.go
set -gx GOPATH $HOME/go
# set -gx GOROOT /usr/local/Cellar/go/1.11.1/libexec
set -gx PATH \
            $ANDROID_HOME/tools/bin \
            $DENO_INSTALL/bin \
            /usr/local/opt/php@7.4/bin \
            $HOME/.config/yarn/global/node_modules/.bin \
            $HOME/.poetry/bin \
            $HOME/.rbenv/shims \
            $HOME/.yarn/bin \
            $HOME/.local/bin \
            $HOME/.go/bin/ \
            $HOME/go/bin/ \
            $HOME/bin \
            /home/kazuya/.gem/ruby/*/bin \
            $HOME/.config/composer/vendor/bin \
            /usr/local/bin \
            /bin \
            $ANDROID_HOME/tools \
            $ANDROID_HOME/platform-tools \
            $HOME/.cargo/bin \
            $PATH ^/dev/null
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx CHROME_BIN chromium

set -gx PIPENV_VENV_IN_PROJECT 1
# set -gx AWS_DEFAULT_PROFILE acro5piano

set -gx CLOUDSDK_PYTHON /usr/bin/python2

set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx LC_CTYPE en_US.UTF-8

set -gx LDFLAGS "-L/usr/local/opt/readline/lib"
set -gx CPPFLAGS "-I/usr/local/opt/readline/include"
set -gx PKG_CONFIG_PATH "/usr/local/opt/readline/lib/pkgconfig"

set -gx GRADLE_OPTS '-Dorg.gradle.jvmargs="-Xmx2048m -XX:+HeapDumpOnOutOfMemoryError"'
set -gx JAVA_OPTS "-Xms512m -Xmx1024m"

set -gx GREP_OPTIONS '--line-buffered'

nvm use 16 >/dev/null 2>/dev/null

set -gx NODE_PATH $NODE_PATH:`npm root -g`

status --is-interactive; and source (rbenv init -|psub)

set -gx FZF_DEFAULT_OPTS "--ansi --preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
# set -gx FZF_DEFAULT_OPTS '--preview-window right:50%:noborder:hidden --color "preview-bg:234" --bind "ctrl-o:toggle-preview"'

# }}}

# {{{ functions

function __fzf_history
  set FILTER fzf-tmux # Not works at all!
  set FILTER fzf
  history | perl -nle 'print if length($_) < 200' | $FILTER -d40% --exact +s +m --query=(commandline -b) --no-preview \
    > /tmp/fzf
  and commandline (cat /tmp/fzf)
end

function __copy_command
  echo (commandline -b) | cl
end

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
    find ~/ghq/ -maxdepth 3 | egrep '/.+/.+/.+/.+/.+/.+' | grep -v DS_Store | fzf-tmux -h --no-preview | read line
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

function diffw
    colordiff -yW (tput cols) $argv
end

function diffc
    colordiff -U3 $argv
end

function seek
    set dir $argv[-1]
    if [ -e $dir ]
        set expression (echo $argv | perl -pe "s#$dir##" | perl -pe 's# +#.+#g')
        rg --color always --heading $expression $dir | perl -nle 'print if length($_) < 200'
    else
        set expression (echo $argv | perl -pe 's# +#.+#g')
        rg --color always --heading $expression | perl -nle 'print if length($_) < 200'
    end
end

# TODO: divide files to os specific file
function cl
    if [ -e /Applications ]
        pbcopy
    else
        wl-copy
    end
end
function clp
    if [ -e /Applications ]
        pbpaste
    else
        wl-paste
    end
end

function grep-replace
    git ls-files | xargs perl -i -pe "s#$argv[1]#$argv[2]#g"
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

function insert
    perl -pe "s#^#$argv[1] #g"
end

function append
    perl -pe "s#\$# $argv[1]#"
end

function delete
    perl -pe "s#$argv[1]##g"
end

function delete_html_tags
    perl -pe "s#<.*?>##g"
end

function vimf
    vim (git ls-files | fzf-tmux)
end

function sp
    bash -c "$argv &"
end

function addone
    ruby -ne 'puts $_.sub(/([0-9]+)/) { |i| i.to_i.next }'
end

function gvm
    bass source ~/.gvm/scripts/gvm ';' gvm $argv
end

function gacp
    git commit -am "$argv" && git ps
end

function gtagp
    git cam "$argv[1]"
    git tag "$argv[2]"
    git pushthis
    git push origin "$argv[2]"
end

function tmsp
    tmux swap-window -t $argv[1]
end

function merge
    set repo (pwd | perl -pe 's#.+github.com/##')

    curl \
        -XPUT \
        -H "Authorization: token $GITHUB_TOKEN" \
        https://api.github.com/repos/$repo/pulls/$argv[1]/merge
end

function clear-branchs
    echo 'removing:'
    git branch | grep -v \* | grep -v master | grep -v develop | perl -pe 's/^/  /'
    echo
    read res -n1 -P 'Continue? [Y/n]'
    if [ res != 'Y' ]
        return
    end
    # git branch | grep -v \* | grep -v master | grep -v develop |  xargs git branch -D
end

function memo
    set dir $HOME/ghq/github.com/acro5piano/var/(date +%Y%m)
    if [ ! -e $dir ]
        mkdir $dir
    end
    nvim $dir/(date +%Y%m%d_%H%M%S).md
end

# }}}

function fish_user_key_bindings
    bind \cr __fzf_history
    bind \e\ch backward-kill-word
    bind \ew __copy_command
    bind \e\cf fzf-file-widget
    bind \ec fzf-cd-widget
end

set git_dirty_color red
set git_clean_color green

function parse_git_branch
    git status >/dev/null 2>/dev/null || return

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

# {{{ aliases

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias 1='cd -'

alias ag='rg'
alias ccat='pygmentize -g'
alias dc='docker-compose'
alias grep='grep --color=auto'
alias la='ls -A'
alias less='less -R'
alias ll='ls -alh'
alias justnow='date +%Y%m%d_%H%M%S'
alias today='date +%Y%m%d'
alias tree='tree --charset XXX -I .git -I vendor -I node_modules'
alias wi='sudo wifi-menu'
alias weather='curl -s wttr.in | sed -n "1,7p"'
alias dp2off='xrandr --output DP2 --off'
alias dp2on='xrandr --output DP2 --above eDP1 --mode 1920x1080'
alias pngcopy='convert - png:- | xclip -i -selection clipboard -t image/png'
alias t='toggl'
alias decode-jwt='jq -R \'split(".") | .[1] | @base64d | fromjson\''

alias rg="rg --hidden --glob '!.git'"
alias ghrw="watch -n 5 gh run list"

alias v="vim"
alias nv="nvim"
alias e="emacs"

alias sum='perl -nale \'$sum += $_; END { print $sum }\''
alias avg='perl -nale \'$sum += $_; END { print $sum / $.}\''

alias csv='column -ts ,'
alias tsv='column -ts \t'
alias tmc='tmux clear-history'

alias q='qrcode'
alias bd='git diff --name-only --diff-filter=d | xargs bat --diff'

# }}}

# {{{ init

[ -e  ~/.traimmu_dotfiles/aliases ]; and source ~/.traimmu_dotfiles/aliases
[ -e  ~/.secret.env ]; and source ~/.secret.env

if which sway >/dev/null 2>/dev/null
    if swaymsg --quiet --type get_tree 2>/dev/null
        if ! tmux list-sessions | grep -q ''
            tmux
        end
    end
end


# if [ -e /etc/arch-release ]
#     sudo sysctl -p > /dev/null &
# end

# }}}

# vim:set ft=bash ts=2 sts=2 sw=2
# vim:set foldmethod=marker:

# The next line updates PATH for the Google Cloud SDK.
set gcp_sdk_path ~/var/google-cloud-sdk/path.fish.inc
[ -f $gcp_sdk_path ] && . $gcp_sdk_path

# If running from tty1 start sway
set TTY1 (tty)
[ "$TTY1" = "/dev/tty1" ] && exec sway

function __nvm-active --on-event fish_prompt
    [ -e .nvmrc ] && nvm use > /dev/null
end
