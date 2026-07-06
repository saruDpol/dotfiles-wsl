local wezterm = require("wezterm")
local config_dir = os.getenv("XDG_CONFIG_HOME") or (wezterm.home_dir .. "/.config")
local mode_file = os.getenv("THEME_MODE_FILE") or (config_dir .. "/theme-mode")

local solarized_osaka = {
	foreground = "#d0d0d0",
	-- background = "#00141a",
	background = "#1b1b1b",
	-- cursor_bg = "#ffcc66",
	-- cursor_fg = "#00141a",
	selection_bg = "#2d4f67",
	selection_fg = "#d0d0d0",
}

local solarized_light = {
	foreground = "#223847",
	background = "#f3ead8",
	cursor_bg = "#2f6fa5",
	cursor_fg = "#f3ead8",
	cursor_border = "#2f6fa5",
	selection_bg = "#d8cbb5",
	selection_fg = "#24313b",
	scrollbar_thumb = "#c8baa2",
	split = "#c8baa2",
	ansi = {
		"#e4d8c4",
		"#aa3f2b",
		"#6a8b52",
		"#9b7440",
		"#2f6fa5",
		"#9b4f70",
		"#3f7e77",
		"#223847",
	},
	brights = {
		"#e7dcc8",
		"#c25434",
		"#7f9b67",
		"#b08852",
		"#4a81b3",
		"#b06483",
		"#4d9089",
		"#1e2a33",
	},
	tab_bar = {
		background = "#ded1bd",
		active_tab = {
			bg_color = "#f3ead8",
			fg_color = "#24313b",
		},
		inactive_tab = {
			bg_color = "#d5c7b1",
			fg_color = "#6f7b84",
		},
		inactive_tab_hover = {
			bg_color = "#e2d5c1",
			fg_color = "#33414c",
		},
		new_tab = {
			bg_color = "#ded1bd",
			fg_color = "#6f7b84",
		},
		new_tab_hover = {
			bg_color = "#e2d5c1",
			fg_color = "#24313b",
		},
	},
}

local function get_mode()
	local f = io.open(mode_file, "r")
	if not f then
		return "dark"
	end
	local value = f:read("*l")
	f:close()
	if value == "light" then
		return "light"
	end
	return "dark"
end

local mode = get_mode()
local active_colors = (mode == "light") and solarized_light or solarized_osaka

if wezterm.add_to_config_reload_watch_list then
	wezterm.add_to_config_reload_watch_list(mode_file)
end

return {
	-- Defaulting to wsl home directory
	default_prog = { "wsl.exe", "-d", "Ubuntu", "--cd", "~", "--", "zsh", "-il" },
	automatically_reload_config = true,
	-- font settings
	font = wezterm.font("Fira Code"),
	font_size = 14.0,

	--	colorscheme
	colors = active_colors,
	window_background_opacity = 0.85,

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
