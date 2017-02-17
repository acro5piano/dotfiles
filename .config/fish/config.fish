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

