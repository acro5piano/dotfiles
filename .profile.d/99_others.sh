# Enable C-s -> I-search
stty stop undef

# Setting for my Office
if [ -e ~/.quick_dotfiles ]; then
    . ~/.quick_dotfiles/.bash_profile
    . ~/.quick_dotfiles/.bash_aliases
fi

