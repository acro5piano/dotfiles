# Setup fzf
# ---------
if [[ ! "$PATH" == */home/kazuya/.fzf/bin* ]]; then
  export PATH="$PATH:/home/kazuya/.fzf/bin"
fi

# Man path
# --------
if [[ ! "$MANPATH" == */home/kazuya/.fzf/man* && -d "/home/kazuya/.fzf/man" ]]; then
  export MANPATH="$MANPATH:/home/kazuya/.fzf/man"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/kazuya/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/kazuya/.fzf/shell/key-bindings.zsh"

