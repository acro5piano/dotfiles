# vim:set ft=bash ts=2 sts=2 sw=2

set -x GOPATH $HOME/.go
set -x PATH $HOME/.go/bin/ $HOME/bin /usr/local/bin /bin $PATH

function gl
  set -l query (commandline)

  if test -n $query
    set fzf_flags --query "$query"
  end

  ghq list -p | fzf $peco_flags | read line

  if [ $line ]
    cd $line
    commandline -f repaint
  end
end

function fish_user_key_bindings
  bind \cr __fzf_history
  bind \e\ch backward-kill-path-component
end

function __fzf_history
  history | fzf-tmux -d40% +s +m --tiebreak=index --query=(commandline -b) \
    > /tmp/fzf
  and commandline (cat /tmp/fzf)
end

function g
  if [ "$argv" ]
    git $argv
  else
    git status
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

alias -='cd -'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'

alias bc='bc -l'
alias clp='xsel -ob'
alias cl='xsel -ib'
alias dc='docker-compose'
alias grep='grep --color=auto'
alias la='ls -A'
alias less='less -R'
alias ll='ls -al'
alias l='ls -CF'
alias ls='ls --color=auto'
alias now='date +%Y%m%d_%H%M%S'
alias seishin='cd (mktemp -d)'
alias tree='tree --charset XXX -I .git -I vendor -I node_modules'
alias wi='sudo wifi-menu'
alias wether='curl -s wttr.in | sed -n "1,7p"'
alias dp2off='xrandr --output DP2 --off'
alias dp2on='xrandr --output DP2 --above eDP1 --mode 1920x1080'

