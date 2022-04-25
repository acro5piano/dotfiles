# vim:set mode=sh

xmodmap $HOME/.xmodmap

xset r rate 200 60

xremap ~/.xremap 2>&1 > /tmp/xremap.log &
start-fcitx &
copyq &
clipmenud &

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

xmodmap ~/.xmodmap

exec i3
