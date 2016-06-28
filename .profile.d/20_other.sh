### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

### written by kazuya

# ruby
export PATH="$HOME/bin:$PATH"

# ruby
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Go
export PATH=$PATH:/usr/local/go/bin

# LANG
export LC_ALL=en_US.utf8
export LANG=en_US.utf8

# Emacs cask
export PATH="~/.cask/bin:$PATH"

# Screen
sudo mkdir /var/run/screen 2>/dev/null
sudo chmod 0777 /var/run/screen
screen -xR

# Enable C-s -> I-search
stty stop undef

# Setting for chromebook
if [ $USER = 'kazuya' ]; then
    if [ -e ~/config/Xmodmap ]; then
        xmodmap ~/.config/Xmodmap
    fi
    # Open jupyter notebook if not running
    #if [ `ps aux | grep jupyter-notebook | wc -l` -eq 1 ]; then
    #    #nohup jupyter-notebook > /dev/null &
    #fi
fi

# Setting for my Office
if [ `hostname` = 'kgosho-ubuntu' ]; then
    . ~/.bash_quick.d/.bash_profile
    . ~/.bash_quick.d/.bash_aliases
fi

# Set fabric env
export FAB_ENV=development

export SCREENDIR=~/.screen

