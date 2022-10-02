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

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

export TERMINAL=alacritty # required for i3

iwctl device wlan0 set-property Powered off & # disable, as I use USB device

xmodmap ~/.xmodmap

exec i3
