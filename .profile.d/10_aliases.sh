# Define my commands alias or function


alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias cl='xsel -ib'
alias clp='xsel -ob'
alias dc='docker-compose'
alias de='docker exec -it'
alias egrep='egrep --color=auto'
alias e='emacs -nw'
alias fgrep='fgrep --color=auto'
alias gita='git add -A . ; git commit -m "ALL Update" ; git push'
alias glook='cd $(ghq root)/$(ghq list | peco)'
alias gitbrowse="git remote && git remote -v | head -1 | cut -d@ -f 2 | tr ':' '/' | cut -d' ' -f 1 | xargs chromium-browser"
alias grep='grep --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias less='less -R'
alias ll='ls -al'
alias ls='ls --color=auto'
alias memo='emacs -nw ~/mynote/memo.org'
alias now='date +%Y%m%d_%H%M%S'
alias sr='screen -xR'
alias seishin-to-tokinoheya='cd $(mktemp -d)'
alias svnco--='svn st | grep ^M | tr -d M | xargs svn revert'
alias tree='tree --charset XXX'
alias tra='trash -rf'
alias ycal='cal `date +%Y`'

mozc(){
    case $1 in
        'dict') /usr/lib/mozc/mozc_tool --mode=dictionary_tool ;;
        'word') /usr/lib/mozc/mozc_tool --mode=word_register_dialog ;;
        'config') /usr/lib/mozc/mozc_tool --mode=config_dialog ;;
        *) echo 'mozc [dict|word]' ;;
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


