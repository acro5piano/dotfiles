# Define my commands alias or function

alias P='cat /tmp/clipboard'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias cl='xsel -ib'
alias egrep='egrep --color=auto'
alias em='emacs -nw'
alias fgrep='fgrep --color=auto'
alias gita='git add -A . ; git commit -m "ALL Update" ; git push'
alias grep='grep --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias less='less -R'
alias ll='ls -alF'
alias ls='ls --color=auto'
alias memo='em ~/mynote/memo.org'
alias sr='screen -xR'
alias tree='tree --charset XXX'

mozc(){
    if [ $1 = 'dict' ]; then
        /usr/lib/mozc/mozc_tool --mode=dictionary_tool
    elif [ $1 = 'word' ]; then
        /usr/lib/mozc/mozc_tool --mode=word_register_dialog
    else
        echo 'mozc [dict|word]'
    fi
}

alarm(){
    echo "echo $1 | cowsay | wall" | at $2
}


alias gita='git add -A . ; git commit -m "ALL Update" ; git push'

cleanse(){
    # example:
    #    echo 'アアaaＡ' | cleanse
    #    => アアAAA

    cat "$1" |
        sed -s 's/(.*)//g' |
        sed -s 's/（.*）//g' |
        sed -s 's/<.*>//g' |
        sed -s 's/＜.*＞//g' |
        sed -s 's/\[.*\]//g' |
        sed -s 's/【.*】//g' |
        sed -s 's/株式会社//g' |
        grep -v ダミー  | grep -v ※  |
        han | nkf -w |
        tr "[:lower:]" "[:upper:]"
}

