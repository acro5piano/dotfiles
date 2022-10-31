local wezterm = require("wezterm")

return {
	default_prog = { "wsl" },
	enable_tab_bar = false,
	default_cwd = "/home/kazuya",
	keys = {
		{
			key = "v",
			mods = "ALT",
			action = wezterm.action.Paste,
		},
	},
}
