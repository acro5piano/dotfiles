# vim:set mode=sh

xmodmap $HOME/.xmodmap

xset r rate 200
xremap ~/.xremap 2>&1 > /tmp/xremap.log &

synclient TapButton1=1
synclient TapButton2=3
synclient TapButton3=2
synclient HorizTwoFingerScroll=1
synclient VertScrollDelta=-111
synclient HorizScrollDelta=-111

exec awesome
