# Start tmux if x is running and no tmux is running
[ "$DISPLAY" ] && [ `pgrep -c tmux` -eq 0 ] && tmux

if [ ! "$DISPLAY" ]; then
    startx
#    read start_x
#    case start_x in
#        'y') start_x ;;
#        "\n") start_x ;;
#    esac
fi
