### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

### written by kazuya

# ruby
export PATH="$HOME/bin:$PATH"

# ruby
export PATH="$HOME/.rbenv/bin:$PATH"
if [ -e $HOME/.rbenv/bin ]; then
    eval "$(rbenv init -)"
fi

# Go
export PATH=$PATH:/usr/local/go/bin

# LANG
export LC_ALL=en_US.utf8
export LANG=en_US.utf8

# Emacs cask
export PATH="~/.cask/bin:$PATH"

# Enable C-s -> I-search
stty stop undef

# Setting for chromebook
if [ $USER = 'kazuya' ]; then
    if [ $DISPLAY ]; then
        xmodmap ~/.xmodmap
    fi
fi

# Setting for my Office
if [ `hostname` = 'kgosho-ubuntu' ]; then
    . ~/.quick_dotfiles/.bash_profile
    . ~/.quick_dotfiles/.bash_aliases
fi

# Set fabric env
export FAB_ENV=development

export SCREENDIR=~/.screen

# Exec screen
#screen -xR

