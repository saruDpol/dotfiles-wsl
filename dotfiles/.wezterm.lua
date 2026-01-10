local wezterm = require("wezterm")

local solarized_osaka = {
	foreground = "#d0d0d0",
	-- background = "#00141a",
	background = "#1b1b1b",
	-- cursor_bg = "#ffcc66",
	-- cursor_fg = "#00141a",
	selection_bg = "#2d4f67",
	selection_fg = "#d0d0d0",
}

return {
	-- Defaulting to wsl home directory
	default_prog = { "wsl.exe", "-d", "Ubuntu", "--cd", "~", "--", "zsh", "-il" },
	automatically_reload_config = true,
	-- font settings
	font = wezterm.font("BlexMono Nerd Font"),
	font_size = 14.0,

	--	colorscheme
	color_schemes = {
		["Solarized Osaka"] = solarized_osaka,
	},
	color_scheme = "Solarized Osaka",
	window_background_opacity = 0.65,

	--Performance tweaks
	enable_wayland = false,
	use_fancy_tab_bar = false,
	window_decorations = "RESIZE",
	enable_scroll_bar = false,
	scrollback_lines = 5500,

	-- initial window size
	initial_cols = 120,
	initial_rows = 50,

	-- Use the fastes renderer
	front_end = "OpenGL",

	-- hide tab bar if only one tab
	hide_tab_bar_if_only_one_tab = true,

	window_padding = {
		left = 25,
		right = 25,
		top = 20,
	},

	wezterm.on("gui-startup", function(cmd)
		local screen = wezterm.gui.screens().active
		local ratio = 0.85
		local width, height = screen.width * ratio, screen.height * ratio
		local tab, pane, window = wezterm.mux.spawn_window({
			position = {
				x = (screen.width - width) / 2,
				y = (screen.height - height) / 3,
				origin = "ActiveScreen",
			},
		})
		-- window:gui_window():maximize()
		window:gui_window():set_inner_size(width, height)
	end),
}
