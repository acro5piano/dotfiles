if [ "$DISPLAY" ]; then
     # Start tmux if x is running and no tmux is running
     [ `pgrep -c tmux` -eq 0 ] && tmux

     # Start emacs server with GUI. Use emacs with `emacsclient`
     # [ `ps aux | grep  'emacs' | wc -l` -lt 2 ] && nohup emacs --reverse > /dev/null &
fi

