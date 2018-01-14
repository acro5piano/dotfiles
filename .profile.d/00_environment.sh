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
export PATH="$HOME/.config/composer/vendor/bin:$PATH"

# pip (???)
export PATH="$HOME/.local/bin:$PATH"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# terminal emulator cannot run emacs so use vim
export VISUAL=eq
export EDITOR=eq


set -s escape-time 0

test -d ~/.linuxbrew && PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
test -d /home/linuxbrew/.linuxbrew && PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
test -r ~/.bash_profile && echo "export PATH='$(brew --prefix)/bin:$(brew --prefix)/sbin'":'"$PATH"' >>~/.bash_profile
echo "export PATH='$(brew --prefix)/bin:$(brew --prefix)/sbin'":'"$PATH"' >>~/.profile

# Enable C-s -> I-search
stty stop undef

# Setting for my Office
if [ -e ~/.quick_dotfiles ]; then
    . ~/.quick_dotfiles/init.sh
fi

# Define my commands alias or function

alias ave="awk '{a+=\$1}END{print a/NR}'"
alias bc='bc -l'
alias cl='xclip -i -selection clipboard'
alias clp='xclip -o -selection clipboard'
alias d='cd $(dirs -v | fzf | cut -f 2)'
alias dc='docker-compose'
alias dce='docker-compose exec -it'
alias de='docker exec -it'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias gita='git add -A . ; git commit -m "ALL Update" ; git push'
alias gl='cd $(ghq root)/$(ghq list | fzf)'
alias grep='grep --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias less='less -R'
alias ll='ls -al'
alias ls='ls --color=auto'
alias now='date +%Y%m%d_%H%M%S'
alias seishin='cd $(mktemp -d)'
alias sum="awk '{a+=\$1}END{print a}'"
alias tree='tree --charset XXX -I .git -I vendor -I node_modules'
alias ycal='cal `date +%Y`'
alias wi='sudo wifi-menu'
alias trim_empty_line="perl -pe 's/^\n$//g'"

mozc(){
    case $1 in
        'dict') /usr/lib/mozc/mozc_tool --mode=dictionary_tool ;;
        'word') /usr/lib/mozc/mozc_tool --mode=word_register_dialog ;;
        'config') /usr/lib/mozc/mozc_tool --mode=config_dialog ;;
        *) echo 'mozc [dict|word|config]' ;;
    esac
}

alarm(){
    echo "tmux detach-client; sleep 1; cowsay_to_single_pts $1" | at $2
}

to_dos(){
    iconv -f utf8 -t sjis | perl -pe 's/\n/\r\n/' < /dev/stdin
}

mcd(){
   mkdir $1
   cd $1
}

gup(){
    echo $PWD
    if [ $PWD = '/' ]; then
        return 1
    elif ls -a | grep -q '^.git$'; then
        return 0
    else
        cd ..
        gup
    fi
}

compress_pdf(){
    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 \
       -dPDFSETTINGS=/default -dNOPAUSE -dQUIET -dBATCH \
       -sOutputFile="$1.minified.pdf" $1
}

datecal(){
    if [ "$1" ]; then
        ruby -r date -e "puts $1"
    else
        pry -r date
    fi
}

g(){
    if [ "$1" ]; then
        git $@
    else
        git status
    fi
}

