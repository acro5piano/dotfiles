# Define my commands alias or function

alias sr='screen -xR'
alias em='emacs -nw'
alias memo='em ~/memo/memo.org'
alias P='cat /tmp/clipboard'
alias tree='tree --charset XXX'
alias less='less -R'
alias cl='xsel -ib'

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

