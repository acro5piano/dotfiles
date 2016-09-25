### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.gem/ruby/2.3.0/bin:$HOME/bin:$PATH"

# rbenv
if [ -e $HOME/.rbenv/bin ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
fi

# Go
export GOPATH=~/.go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

# LANG
export LC_ALL=en_US.utf8
export LANG=en_US.utf8

# Emacs cask
export PATH="$HOME/.cask/bin:$PATH"

# Set fabric env
export FAB_ENV=development

# Composer
export PATH="$HOME/.composer/vendor/bin:$PATH"

# pip (???)
export PATH="$HOME/.local/bin:$PATH"

# set vim as my normal editor
export visual=vim
