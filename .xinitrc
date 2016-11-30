export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
gsettings set org.gnome.settings-daemon.plugins.xsettings overrides "{'Gtk/IMModule':<'fcitx'>}"

fcitx-autostart

# Set mime type

xdg-mime default chromium.desktop text/html
xdg-mime default libreoffice text/csv

xdg-mime default chromium.desktop x-scheme-handler/http
xdg-mime default chromium.desktop x-scheme-handler/https
xdg-mime default evince.desktop application/pdf

xdg-settings set default-web-browser browser.desktop

# Concat openbox settings
cat ~/.config/openbox/rc.d/* > ~/.config/openbox/rc.xml

# Emacs gui setting
xrdb ~/.Xresources

# Keyboard repeat fre.
xset r rate 250

xscreensaver -no-splash &

# Multi display

xrandr --output HDMI1 --above eDP1 --mode 1920x1080
xrandr --output DP2 --above eDP1 --mode 1920x1080
xrandr --output VGA1 --above LVDS1 --mode 1920x1080
xrandr --output DP1 --right-of VGA1 --mode 1920x1080
feh  --bg-fill $HOME/.config/wallpapers/stock-photo-22857547.jpg

pgrep terminator > /dev/null || terminator &

synclient TapButton1=1
synclient TapButton2=1
synclient TapButton3=1
synclient CircularScrolling=1

# Set default applications
xdg-mime default pcmanfm.desktop inode/directory
xdg-mime default chromium.desktop text/html

# change Caps -> Ctrl
if ! (lsusb | grep -q HHKB); then
    if [ `hostname` = 'lets_note' ]; then
        xmodmap $HOME/.xmodmap.d/jp
    elif [ `hostname` = 'chromebook' ]; then
        xmodmap $HOME/.xmodmap.d/chromebook
    elif [ `hostname` = 'thinkpad' ]; then
        xmodmap $HOME/.xmodmap.d/us
    fi
fi

#exec openbox-session
exec awesome
