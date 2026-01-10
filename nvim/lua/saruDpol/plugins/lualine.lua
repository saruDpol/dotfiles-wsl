local colors = {
	black = "#383a42",
	white = "#e5e5e5",
	orange = "#cc543a",
	red = "#d0140e",
	green = "#bec23f",
	blue = "#124f5e",
	blue_japan = "#33a6b8",
	purple = "#6c71c4",
	pink = "#f255a1",
	darkblue = "#012b36",

	-- Japanese Gold Gradient
	gold1 = "#f9bf45", -- Usukinkei (pale gold)
	gold2 = "#c99833", -- Hana-kin (soft light gold)
	gold3 = "#ba9132", -- Koganeiro (classic gold)
	gold4 = "#dcb879", -- Yamabuki-iro (marigold gold)
	gold5 = "#efbb24", -- Kincha (golden brown)
	gold6 = "#f7c242", -- Tsuchikusa (earthy gold)
	gold7 = "#fad689", -- Kurogane (antique dark gold)

	-- Legacy/compatibility
	gold = "#FFD700", -- Base gold (classic)
	lightgold = "#FFE9A9", -- Soft light variant
	darkgold = "#5C4A1F", -- Deep antique gold
	anothergold = "#FFB11B", -- Yamabuki highlight
}
return { -- Statusline
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			icons_enabled = true,
			--theme = "solarized_dark",
			theme = {
				normal = {
					a = { fg = colors.darkblue, bg = colors.gold3, gui = "bold" },
					b = { fg = colors.white, bg = colors.grey },
					c = { fg = colors.white, bg = colors.blue },
					z = { fg = colors.darkblue, bg = colors.gold3, gui = "bold" },
				},
				insert = {
					a = { fg = colors.white, bg = colors.orange, gui = "bold" },
					z = { fg = colors.white, bg = colors.orange, gui = "bold" },
				},
				visual = {
					a = { fg = colors.white, bg = colors.blue_japan, gui = "bold" },
					z = { fg = colors.white, bg = colors.blue_japan, gui = "bold" },
				},
				replace = {
					a = { fg = colors.white, bg = colors.purple, gui = "bold" },
					z = { fg = colors.white, bg = colors.purple, gui = "bold" },
				},
				command = {
					a = { fg = colors.darkblue, bg = colors.green, gui = "bold" },
					z = { fg = colors.darkblue, bg = colors.green, gui = "bold" },
				},
			},
			component_separators = { left = "|", right = "|" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = {
				statusline = {},
				winbar = {},
			},
			ignore_focus = {},
			always_divide_middle = true,
			always_show_tabline = true,
			globalstatus = true,
			refresh = {
				statusline = 100,
				tabline = 100,
				winbar = 100,
			},
		},
		sections = {
			lualine_a = {
				{ "mode", separator = { left = "" }, right_padding = 2 },
			},
			lualine_b = {
				{
					"branch",
					separator = { left = "░▒▓", right = "" },
					color = { fg = colors.white, bg = "#012b36" },
					fmt = function(str)
						if str == nil or str == "" then
							return " " -- blank space if no branch
						end
						return str
					end,
				},
				{
					"diagnostics",
					symbols = { error = " ", warn = " ", info = " " },
					separator = { right = "" },
					color = { bg = "#063642" },
					diagnostics_color = {
						color_error = { fg = "#b7221e" },
						color_warn = { fg = "#ffc102" },
						color_info = { fg = "#27eedf" },
					},
					fmt = function(str)
						if str == nil or str == "" then
							return " " -- blank space if no diagnostics
						end
						return str
					end,
				},
			},
			lualine_c = { { "filename", path = 2, color = { fg = "#d6a04a", bg = "#124f5e" } } },
			lualine_x = {
				{ "encoding", color = { bg = "#124f5e" } },
				{ "fileformat", color = { bg = "#124f5e" } },
				{ "filetype", separator = { right = "" }, color = { bg = "#124f5e" } },
			},
			lualine_y = {
				{
					"progress",
					separator = { right = "▓▒░" },
					color = { fg = "#d6a04a", bg = colors.darkblue },
				},
			},
			lualine_z = {
				{ "location", separator = { right = "" }, left_padding = 2 },
			},
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = { "filename" },
			lualine_c = {},
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {},
		winbar = {},
		inactive_winbar = {},
		extensions = {},
		disabled_sections = {},
	},
}
