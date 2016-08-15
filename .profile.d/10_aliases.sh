# Define my commands alias or function


alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias cl='xsel -ib'
alias clp='xsel -ob'
alias egrep='egrep --color=auto'
alias e='emacs -nw'
alias em='emacs'
alias fgrep='fgrep --color=auto'
alias gita='git add -A . ; git commit -m "ALL Update" ; git push'
alias grep='grep --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias less='less -R'
alias ll='ls -al'
alias ls='ls --color=auto'
alias memo='emacs -nw ~/mynote/memo.org'
alias now='date +%Y%m%d_%H%M%S'
alias sr='screen -xR'
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
    echo "echo $1 | cowsay | wall" | at $2
}




to_dos(){
    iconv -f utf8 -t sjis | perl -pe 's/\n/\r\n/' < /dev/stdin
}

