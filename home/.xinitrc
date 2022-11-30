# vim:set mode=sh

xmodmap $HOME/.xmodmap

xdg-settings set default-web-browser brave.desktop
xdg-mime default feh.desktop image/png image/jpg image/jpeg image/gif image/bmp image/x-xcf image/webp
xdg-mime default gnumeric.desktop text/csv
xdg-mime default brave.desktop application/pdf

xset -dpms
xset s off
xset dpms 0 0 0
xset r rate 230 60

xremap ~/.xremap 2>&1 > /tmp/xremap.log &
start-fcitx &
copyq &
CM_SELECTIONS=clipboard clipmenud &
nohup ~/bin/xset-auto.py > /dev/null &

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export GLFW_IM_MODULE=ibus # required for Kitty terminal
export TERMINAL=kitty # required for i3

iwctl device wlan0 set-property Powered off & # disable, as I use USB device

# For surface device
# export QT_AUTO_SCREEN_SCALE_FACTOR=2
# export GDK_SCALE=2
# xrandr --output eDP-1 --dpi 190

feh --bg-scale ~/.dotfiles/wallpapers/autumn-load.jpg

xmodmap ~/.xmodmap

light -S 10

exec i3
