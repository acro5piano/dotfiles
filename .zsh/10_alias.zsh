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

# enable color support of ls and also add handy aliases
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
# Add an "alert" alias for long running commands.  Use like so:
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
# ~/.bash_aliases, instead of adding them here directly.

