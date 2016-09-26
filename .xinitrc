export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
gsettings set org.gnome.settings-daemon.plugins.xsettings overrides "{'Gtk/IMModule':<'fcitx'>}"

fcitx-autostart

remove lock = Control_L
keycode 66 = Control_R
add control = Control_R

keycode 97 = Shift_R
add shift = Shift_R

exec openbox-session
