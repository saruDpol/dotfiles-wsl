local wezterm = require("wezterm")
local config_dir = os.getenv("XDG_CONFIG_HOME") or (wezterm.home_dir .. "/.config")
local mode_file = config_dir .. "/theme-mode"

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
	foreground = "#586e75",
	background = "#fdf6e3",
	selection_bg = "#eee8d5",
	selection_fg = "#586e75",
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
local selected_scheme = (mode == "light") and "Solarized Light Custom" or "Solarized Osaka"

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
		["Solarized Light Custom"] = solarized_light,
	},
	color_scheme = selected_scheme,
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
