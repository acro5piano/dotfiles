# vim:set mode=sh

export PATH="$HOME/bin:$PATH"

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
fcitx-autostart

# Set mime type, or default applications
xdg-settings set default-web-browser browser.desktop
xdg-mime default google-chrome-stable.desktop text/html
xdg-mime default libreoffice.desktop text/csv
xdg-mime default libreoffice.desktop application/docx
xdg-mime default google-chrome-stable.desktop x-scheme-handler/http
xdg-mime default google-chrome-stable.desktop x-scheme-handler/https
xdg-mime default evince.desktop application/pdf
xdg-mime default pcmanfm.desktop inode/directory
xdg-mime default google-chrome-stable.desktop text/html

# Keyboard repeat frequency
xset r rate 250

# Multi display
xrandr --output DP-2 --above eDP-1 --mode 1920x1080

# wallpaper
feh --bg-fill $HOME/.config/wallpapers/iceland.jpg

# Run terminal when not run
pgrep terminator > /dev/null || terminator &
pgrep google-chrome-stable > /dev/null || google-chrome-stable &

# touchpad
synclient TapButton1=1
synclient TapButton2=3
synclient TapButton3=2
synclient HorizTwoFingerScroll=1
synclient VertScrollDelta=-111
synclient HorizScrollDelta=-111

# keyboard layout customize
xmodmap $HOME/.xmodmap

bash -c 'sleep 5; xremap ~/.xremap 2>&1 > /tmp/xremap.log &'

exec awesome
