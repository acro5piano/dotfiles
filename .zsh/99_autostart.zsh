# Start tmux if x is running and no tmux is running
[ "$DISPLAY" ] && [ `pgrep -c tmux` -eq 0 ] && tmux

[ "$DISPLAY" ] || startx
