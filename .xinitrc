export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
gsettings set org.gnome.settings-daemon.plugins.xsettings overrides "{'Gtk/IMModule':<'fcitx'>}"

fcitx-autostart

# Set mime type, or default applications
xdg-settings set default-web-browser browser.desktop
xdg-mime default chromium.desktop text/html
xdg-mime default libreoffice text/csv
xdg-mime default chromium.desktop x-scheme-handler/http
xdg-mime default chromium.desktop x-scheme-handler/https
xdg-mime default evince.desktop application/pdf
xdg-mime default pcmanfm.desktop inode/directory
xdg-mime default chromium.desktop text/html

# Concat openbox settings
#cat ~/.config/openbox/rc.d/* > ~/.config/openbox/rc.xml

# Emacs gui setting
xrdb ~/.Xresources

# Keyboard repeat frequency
xset r rate 250

xscreensaver -no-splash &

# Multi display
xrandr --output HDMI1 --above eDP1 --mode 1920x1080
xrandr --output DP2 --above eDP1 --mode 1920x1080
xrandr --output VGA1 --above LVDS1 --mode 1920x1080
xrandr --output DP1 --right-of VGA1 --mode 1920x1080

# wallpaper
feh  --bg-fill $HOME/.config/wallpapers/stock-photo-22857547.jpg

# Run terminal when not run
pgrep terminator > /dev/null || terminator &

# touchpad
synclient TapButton1=1
synclient TapButton2=1
synclient TapButton3=1
#synclient CircularScrolling=1

# keyboard layout customize
if [ `hostname` = 'thinkpad' ]; then
    xmodmap $HOME/.xmodmap.d/thinkpad
elif [ `hostname` = 'office' ]; then
    xmodmap $HOME/.xmodmap.d/realforce
fi

#exec openbox-session
exec awesome
