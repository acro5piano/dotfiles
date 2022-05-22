# vim:set mode=sh

xmodmap $HOME/.xmodmap

xset r rate 200 60

xremap ~/.xremap 2>&1 > /tmp/xremap.log &
start-fcitx &
copyq &
CM_SELECTIONS=clipboard clipmenud &

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

export TERMINAL=alacritty # required for i3

xmodmap ~/.xmodmap

exec i3
