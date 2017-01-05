# Define my commands alias or function

alias ave="awk '{a+=\$1}END{print a/NR}'"
alias bc='bc -l'
alias cl='xsel -ib'
alias clp='xsel -ob'
alias d='cd $(dirs -v | peco | cut -f 2)'
alias dc='docker-compose'
alias dce='docker-compose exec -it'
alias de='docker exec -it'
alias g='git status'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias gita='git add -A . ; git commit -m "ALL Update" ; git push'
alias gl='cd $(ghq root)/$(ghq list | peco)'
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
