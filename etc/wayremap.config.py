from wayremap import ecodes as e, run, WayremapConfig, Binding, wait_sway
import uinput as k

applications = [
    "Brave-browser",
    "Leafpad",
    "firefoxdeveloperedition",
    "Chromium",
    "Slack",
    "Pcmanfm",
    "Google-chrome-beta",
    "Vivaldi-snapshot",
    "Vivaldi-stable",
]

bindings = [
    # Alternative
    Binding([e.KEY_LEFTCTRL, e.KEY_LEFTALT, e.KEY_D], [[k.KEY_LEFTCTRL, k.KEY_D]]),
    Binding([e.KEY_LEFTALT, e.KEY_P], [[k.KEY_LEFTCTRL, k.KEY_LEFTSHIFT, k.KEY_A]]),
    Binding([e.KEY_LEFTALT, e.KEY_S], [[k.KEY_LEFTCTRL, k.KEY_S]]),
    Binding([e.KEY_LEFTALT, e.KEY_N], [[k.KEY_LEFTCTRL, k.KEY_N]]),
    # Slack helm!
    Binding([e.KEY_LEFTALT, e.KEY_X], [[k.KEY_LEFTCTRL, k.KEY_K]]),
    # Emacs-like key binding
    Binding([e.KEY_LEFTCTRL, e.KEY_LEFTALT, e.KEY_A], [[k.KEY_LEFTCTRL, k.KEY_HOME]]),
    Binding([e.KEY_LEFTCTRL, e.KEY_LEFTALT, e.KEY_E], [[k.KEY_LEFTCTRL, k.KEY_END]]),
    Binding(
        [e.KEY_LEFTCTRL, e.KEY_LEFTALT, e.KEY_H], [[k.KEY_LEFTCTRL, k.KEY_BACKSPACE]]
    ),
    Binding([e.KEY_LEFTCTRL, e.KEY_F], [[k.KEY_RIGHT]]),
    Binding([e.KEY_LEFTCTRL, e.KEY_B], [[k.KEY_LEFT]]),
    Binding([e.KEY_LEFTCTRL, e.KEY_P], [[k.KEY_UP]]),
    Binding([e.KEY_LEFTCTRL, e.KEY_N], [[k.KEY_DOWN]]),
    Binding([e.KEY_LEFTALT, e.KEY_D], [[k.KEY_LEFTCTRL, k.KEY_DELETE]]),
    Binding([e.KEY_LEFTCTRL, e.KEY_D], [[k.KEY_DELETE]]),
    Binding(
        [e.KEY_LEFTCTRL, e.KEY_K],
        [[k.KEY_LEFTSHIFT, k.KEY_END], [k.KEY_LEFTCTRL, k.KEY_X]],
    ),
    Binding([e.KEY_LEFTCTRL, e.KEY_A], [[k.KEY_HOME]]),
    Binding([e.KEY_LEFTCTRL, e.KEY_E], [[k.KEY_END]]),
    Binding([e.KEY_LEFTCTRL, e.KEY_Y], [[k.KEY_LEFTCTRL, k.KEY_V]]),
    Binding([e.KEY_LEFTALT, e.KEY_F], [[k.KEY_LEFTCTRL, k.KEY_RIGHT]]),
    Binding([e.KEY_LEFTALT, e.KEY_B], [[k.KEY_LEFTCTRL, k.KEY_LEFT]]),
    Binding([e.KEY_LEFTCTRL, e.KEY_H], [[k.KEY_BACKSPACE]]),
    Binding([e.KEY_LEFTCTRL, e.KEY_S], [[k.KEY_LEFTCTRL, k.KEY_F]]),
    # OSX-like key binding
    Binding([e.KEY_LEFTALT, e.KEY_A], [[k.KEY_LEFTCTRL, k.KEY_A]]),
    Binding([e.KEY_LEFTALT, e.KEY_C], [[k.KEY_LEFTCTRL, k.KEY_C]]),
    Binding([e.KEY_LEFTALT, e.KEY_V], [[k.KEY_LEFTCTRL, k.KEY_V]]),
    # TODO: alt keys are pripritize??
    Binding([e.KEY_LEFTALT, e.KEY_K], [[k.KEY_LEFTCTRL, k.KEY_K]]),
    Binding([e.KEY_LEFTALT, e.KEY_H], [[k.KEY_LEFTCTRL, k.KEY_H]]),
    Binding([e.KEY_LEFTALT, e.KEY_E], [[k.KEY_LEFTCTRL, k.KEY_E]]),
]

wait_sway()

run(
    WayremapConfig(
        input_path="/dev/input/event4",
        applications=applications,
        bindings=bindings,
    ),
    WayremapConfig(
        input_identifier="Lenovo TrackPoint Keyboard II usb-0000:00:14.0-1/input0",
        applications=applications,
        bindings=bindings,
    ),
)
