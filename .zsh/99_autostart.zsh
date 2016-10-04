# Start tmux if x is running and no tmux is running
[ "$DISPLAY" ] && [ `pgrep -c tmux` -eq 0 ] && tmux

# Start emacs server. Use emacs with `emacsclient`
[ "$DISPLAY" ] && [ `ps aux | grep  'emacs' | wc -l` -lt 4 ] && emacs --reverse &

if [ ! "$DISPLAY" ]; then
    startx
#    read start_x
#    case start_x in
#        'y') start_x ;;
#        "\n") start_x ;;
#    esac
fi
