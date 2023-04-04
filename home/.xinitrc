# vim:set ft=sh :

xdg-settings set default-web-browser brave.desktop
xdg-mime default feh.desktop image/png image/jpg image/jpeg image/gif image/bmp image/x-xcf image/webp
xdg-mime default gnumeric.desktop text/csv
xdg-mime default brave.desktop application/pdf

xset -dpms
xset s off
xset dpms 0 0 0
# xset r rate 230 60
xset r rate 300 60

start-fcitx &
copyq &
CM_DIR=~/tmp CM_SELECTIONS=clipboard clipmenud &
nohup ~/bin/xset-auto.py > /dev/null &
dunst &
pavucontrol-qt &
xremap ~/.xremap 2>&1 > /tmp/xremap.log &

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export GLFW_IM_MODULE=ibus # required for Kitty terminal
export TERMINAL=kitty # required for i3

# For surface device
# export QT_AUTO_SCREEN_SCALE_FACTOR=2
# export GDK_SCALE=2
# xrandr --output eDP-1 --dpi 190

feh --bg-scale ~/.dotfiles/wallpapers/autumn-load.jpg

xmodmap ~/.xmodmap

# I'm not sure of the reason, but this is required for initial connection establishment
sudo systemctl restart iwd

light -S 5

exec i3
