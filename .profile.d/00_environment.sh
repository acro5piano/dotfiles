### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

### written by kazuya
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
export PATH="$HOME/.cask/bin:$PATH"


# Set fabric env
export FAB_ENV=development

