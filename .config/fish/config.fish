# {{{ Env vars

if [ -e /Applications ]
    set -gx IS_MAC 1
else
    set -gx IS_MAC 0
end

set -gx ANDROID_HOME /opt/android-sdk ^/dev/null

if [ -e $HOME/Library/Android ]
    set -gx JAVA_HOME (/usr/libexec/java_home)
    set -gx STUDIO_JDK /Library/Java/JavaVirtualMachines/jdk-10.jdk
    set -gx ANDROID_HOME $HOME/Library/Android/sdk
end

# [ -e $HOME/.go ]; or mkdir $HOME/.go
# set -gx GOPATH $HOME/.go ^/dev/null
# set -gx GOROOT /usr/local/Cellar/go/1.11.1/libexec
set -gx PATH \
            $HOME/.poetry/bin \
            $HOME/.rbenv/shims \
            $HOME/.yarn/bin \
            $HOME/.config/yarn/global/node_modules/.bin \
            $HOME/.local/bin \
            $HOME/.go/bin/ \
            $HOME/go/bin/ \
            $HOME/bin \
            $HOME/.gem/ruby/2.4.0/bin \
            $HOME/.gem/ruby/2.5.0/bin \
            $HOME/.nvm/versions/node/v10.3.0/bin \
            $HOME/.nvm/versions/node/v10.13.0/bin \
            $HOME/.config/composer/vendor/bin \
            /usr/local/bin \
            /bin \
            $ANDROID_HOME/tools \
            $ANDROID_HOME/platform-tools \
            $HOME/.cargo/bin \
            $PATH ^/dev/null
set -gx EDITOR vim
set -gx VISUAL vim
set -gx CHROME_BIN chromium

set -gx PIPENV_VENV_IN_PROJECT 1
# set -gx AWS_DEFAULT_PROFILE acro5piano

set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx LC_CTYPE en_US.UTF-8

set -gx LDFLAGS "-L/usr/local/opt/readline/lib"
set -gx CPPFLAGS "-I/usr/local/opt/readline/include"
set -gx PKG_CONFIG_PATH "/usr/local/opt/readline/lib/pkgconfig"

set -gx GRADLE_OPTS '-Dorg.gradle.jvmargs="-Xmx2048m -XX:+HeapDumpOnOutOfMemoryError"'
set -gx JAVA_OPTS "-Xms512m -Xmx1024m"

# }}}

# {{{ functions

function delete-all-tables
    echo 'if it is ok, press ^d'
    cat
    mysqldump -u homestead -psecret \
      --add-drop-table --no-data -P 33060 homestead -h 127.0.0.1 | \
      grep -e '^DROP \| FOREIGN_KEY_CHECKS' | \
      mysql -u homestead -psecret -P 33060 -h 127.0.0.1 homestead
end

function __fzf_history
  history | perl -nle 'print if length($_) < 200' | fzf-tmux --exact -d40% +s +m --query=(commandline -b) \
    > /tmp/fzf
  and commandline (cat /tmp/fzf)
end

function __copy_command
  echo (commandline -b) | cl
end

function git_shortcut
end


function gh
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
    find ~/ghq/ -maxdepth 3 | egrep '/.+/.+/.+/.+/.+/.+' | grep -v DS_Store | fzf | read line
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
        xclip -i -selection clipboard
    end
end
function clp
    if [ -e /Applications ]
        pbpaste
    else
        xclip -o -selection clipboard
    end
end

function grep-replace
    git ls-files | xargs perl -i -pe "s/$argv[1]/$argv[2]/g"
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

function nvm_fish
    bass source ~/.nvm/nvm.sh ';' nvm $argv
end

function gvm
    bass source ~/.gvm/scripts/gvm ';' gvm $argv
end

function gcamp
    git cam "$argv[1]"
    and git pushthis
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

# {{{ aliases

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias 1='cd -'

alias ag='rg'
alias rg='rg --hidden'
alias bc='bc -l'
#alias cl='xclip -i -selection clipboard'
#alias clp='xclip -o -selection clipboard'
alias ccat='pygmentize -g'
alias dc='docker-compose'
alias grep='grep --color=auto'
alias la='ls -A'
alias less='less -R'
alias ll='ls -alh'
alias justnow='date +%Y%m%d_%H%M%S'
alias today='date +%Y%m%d'
alias seishin='cd (mktemp -d)'
alias tree='tree --charset XXX -I .git -I vendor -I node_modules'
alias wi='sudo wifi-menu'
alias wether='curl -s wttr.in | sed -n "1,7p"'
alias dp2off='xrandr --output DP2 --off'
alias dp2on='xrandr --output DP2 --above eDP1 --mode 1920x1080'
alias killer="ps aux | fzf --tac | awk -F\  '{print $2}' | xargs kill"
alias murder="ps aux | fzf --tac | awk '{print $2}' | xargs kill -9"
alias pngcopy='convert - png:- | xclip -i -selection clipboard -t image/png'

alias v="vagrant up; vagrant ssh"
alias vr="vagrant reload; vagrant ssh"
alias vs="vagrant suspend"

alias sum='perl -nale \'$sum += $_; END { print $sum }\''
alias avg='perl -nale \'$sum += $_; END { print $sum / $.}\''

alias csv='column -ts ,'
alias tsv='column -ts \t'
alias tmc='tmux clear-history'

alias devtomaster="open (hub pull-request -h develop -b master -m 'production deploy')"

# }}}

# {{{ init

[ -e  ~/.traimmu_dotfiles/aliases ]; and source ~/.traimmu_dotfiles/aliases
[ -e  ~/.secret.env ]; and source ~/.secret.env

# if [ $IS_MAC -eq 0 ]
#     pgrep xremap > /dev/null; or bash -c 'nohup xremap ~/.xremap 2>&1 >/dev/null &'
# end

if [ "$TERM" = 'xterm-256color' ]
    if pgrep tmux > /dev/null
        # tmux a ^ /dev/null
    else
        tmux
    end
end

if [ -e /etc/arch-release ]
    sudo sysctl -p > /dev/null &
end

# bass source ~/.gvm/scripts/gvm

# }}}

# vim:set ft=bash ts=2 sts=2 sw=2
# vim:set foldmethod=marker:
