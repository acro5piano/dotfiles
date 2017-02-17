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

# function fish_user_key_bindings
#   bind \cr fzf_select_history
# end

function g
  if [ "$argv" ]
    git $argv
  else
    git status
  end
end

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
