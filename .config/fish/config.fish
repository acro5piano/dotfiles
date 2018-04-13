# {{{ Env vars

set -gx ANDROID_HOME /opt/android-sdk ^/dev/null

if [ -e /Applications ]
    set -gx JAVA_HOME (/usr/libexec/java_home)
    set -gx STUDIO_JDK /Library/Java/JavaVirtualMachines/jdk-10.jdk
    set -gx ANDROID_HOME $HOME/Library/Android/sdk
end

set -gx GOPATH $HOME/.go ^/dev/null
set -gx PATH \
            $HOME/.yarn/bin \
            $HOME/.config/yarn/global/node_modules/.bin \
            $HOME/.nvm/versions/node/v8.4.0/bin \
            $HOME/.local/bin \
            $HOME/.go/bin/ \
            $HOME/bin \
            $HOME/.gem/ruby/2.4.0/bin \
            $HOME/.config/composer/vendor/bin \
            /usr/local/bin \
            /bin \
            $ANDROID_HOME/tools\
            $ANDROID_HOME/platform-tools\
            $PATH ^/dev/null
set -gx EDITOR vim
set -gx VISUAL vim
set -gx CHROME_BIN chromium

set -gx PIPENV_VENV_IN_PROJECT 1

set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx LC_CTYPE en_US.UTF-8




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
  history | perl -nle 'print if length($_) < 120' | fzf-tmux -d40% +s +m --query=(commandline -b) \
    > /tmp/fzf
  and commandline (cat /tmp/fzf)
end

function __copy_command
  echo (commandline -b) | xclip -i -selection clipboard
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
    find ~/ghq/ -maxdepth 3 | egrep '/.+/.+/.+/.+/.+/.+' | fzf | read line
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

function git-open
    git remote -v | perl -pe 's/[ ]/\n/g' | head -1 | perl -pe 's;^.+git@(.+)\.git;https://\1;g' | xargs chromium
end

function dot
    cd ~/.dotfiles
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

# }}}

# {{{ aliases

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias 1='cd -'

alias ag='rg'
alias bc='bc -l'
#alias cl='xclip -i -selection clipboard'
#alias clp='xclip -o -selection clipboard'
alias ccat='pygmentize -g'
alias dc='docker-compose'
alias grep='grep --color=auto'
alias la='ls -A'
alias less='less -R'
alias ll='ls -alh'
alias now='date +%Y%m%d_%H%M%S'
alias seishin='cd (mktemp -d)'
alias tree='tree --charset XXX -I .git -I vendor -I node_modules'
alias wi='sudo wifi-menu'
alias wether='curl -s wttr.in | sed -n "1,7p"'
alias dp2off='xrandr --output DP2 --off'
alias dp2on='xrandr --output DP2 --above eDP1 --mode 1920x1080'
alias killer="ps aux | fzf --tac | awk -F\  '{print $2}' | xargs kill"
alias murder="ps aux | fzf --tac | awk '{print $2}' | xargs kill -9"
alias pngcopy='convert - png:- | xclip -i -selection clipboard -t image/png'
alias dev2master="git co develop; and git pull; and hub pull-request -b master"

alias v="vagrant up; vagrant ssh"
alias vr="vagrant reload; vagrant ssh"
alias vs="vagrant suspend"

alias sum='perl -nale \'$sum += $_; END { print $sum }\''
alias avg='perl -nale \'$sum += $_; END { print $sum / $.}\''

alias csv='column -ts ,'
alias tsv='column -ts \t'
# }}}

# {{{ init

[ -e  ~/.traimmu_dotfiles/aliases ]; and source ~/.traimmu_dotfiles/aliases

pgrep xremap > /dev/null; or bash -c 'nohup xremap ~/.xremap 2>&1 >/dev/null &'

if [ "$TERM" = 'xterm-256color' ]
    if pgrep tmux > /dev/null
        # tmux a ^ /dev/null
    else
        tmux
    end
end

# }}}

# vim:set ft=bash ts=2 sts=2 sw=2
# vim:set foldmethod=marker:
