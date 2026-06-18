local colors = {
	dark = {
		white = "#e5e5e5",
		orange = "#cc543a",
		red = "#d0140e",
		green = "#bec23f",
		blue = "#124f5e",
		blue_japan = "#33a6b8",
		purple = "#6c71c4",
		darkblue = "#012b36",
		gold = "#ba9132",
		filename = "#d6a04a",
		diagnostics = "#063642",
		branch = "#012b36",
	},
	light = {
		ink = "#24313b",
		navy = "#223847",
		text = "#33414c",
		soft = "#55646f",
		paper = "#f3ead8",
		cloud = "#d8cbb5",
		mist = "#dce8ef",
		blue = "#2f6fa5",
		green_dark = "#4f7040",
		green = "#6a8b52",
		green_light = "#86a06a",
		red = "#aa3f2b",
		red_dark = "#7e261f",
		gold = "#ba9132",
		gold_soft = "#d2bc86",
		teal = "#3f7e77",
	},
}

local function build_theme(mode)
	if mode == "light" then
		return {
			normal = {
				a = { fg = colors.light.navy, bg = colors.light.gold, gui = "bold" },
				b = { fg = colors.light.paper, bg = colors.light.red },
				c = { fg = colors.light.paper, bg = colors.light.green_dark },
				z = { fg = colors.light.navy, bg = colors.light.gold, gui = "bold" },
			},
			insert = {
				a = { fg = colors.light.paper, bg = colors.light.red, gui = "bold" },
				z = { fg = colors.light.paper, bg = colors.light.red, gui = "bold" },
			},
			visual = {
				a = { fg = colors.light.paper, bg = colors.light.blue, gui = "bold" },
				z = { fg = colors.light.paper, bg = colors.light.blue, gui = "bold" },
			},
			replace = {
				a = { fg = colors.light.paper, bg = colors.light.green, gui = "bold" },
				z = { fg = colors.light.paper, bg = colors.light.green, gui = "bold" },
			},
			command = {
				a = { fg = colors.light.navy, bg = colors.light.gold, gui = "bold" },
				z = { fg = colors.light.navy, bg = colors.light.gold, gui = "bold" },
			},
			inactive = {
				a = { fg = colors.light.soft, bg = colors.light.paper },
				b = { fg = colors.light.soft, bg = colors.light.paper },
				c = { fg = colors.light.soft, bg = colors.light.paper },
			},
		}
	end

	return {
		normal = {
			a = { fg = colors.dark.darkblue, bg = colors.dark.gold, gui = "bold" },
			b = { fg = colors.dark.white, bg = colors.dark.branch },
			c = { fg = colors.dark.white, bg = colors.dark.blue },
			z = { fg = colors.dark.darkblue, bg = colors.dark.gold, gui = "bold" },
		},
		insert = {
			a = { fg = colors.dark.white, bg = colors.dark.orange, gui = "bold" },
			z = { fg = colors.dark.white, bg = colors.dark.orange, gui = "bold" },
		},
		visual = {
			a = { fg = colors.dark.white, bg = colors.dark.blue_japan, gui = "bold" },
			z = { fg = colors.dark.white, bg = colors.dark.blue_japan, gui = "bold" },
		},
		replace = {
			a = { fg = colors.dark.white, bg = colors.dark.purple, gui = "bold" },
			z = { fg = colors.dark.white, bg = colors.dark.purple, gui = "bold" },
		},
		command = {
			a = { fg = colors.dark.darkblue, bg = colors.dark.green, gui = "bold" },
			z = { fg = colors.dark.darkblue, bg = colors.dark.green, gui = "bold" },
		},
	}
end

local function build_sections(mode)
	if mode == "light" then
		return {
			lualine_a = {
				{ "mode", separator = { left = "" }, right_padding = 2 },
			},
			lualine_b = {
				{
					"branch",
					separator = { left = "░▒▓", right = "" },
					color = { fg = colors.light.paper, bg = colors.light.red },
					fmt = function(str)
						if str == nil or str == "" then
							return " "
						end
						return str
					end,
				},
				{
					"diagnostics",
					symbols = { error = " ", warn = " ", info = " " },
					separator = { right = "" },
					color = { fg = colors.light.navy, bg = colors.light.gold_soft },
					diagnostics_color = {
						error = { fg = colors.light.red_dark },
						warn = { fg = colors.light.gold },
						info = { fg = colors.light.blue },
						hint = { fg = colors.light.green_dark },
					},
					fmt = function(str)
						if str == nil or str == "" then
							return " "
						end
						return str
					end,
				},
			},
			lualine_c = {
				{ "filename", path = 2, color = { fg = colors.light.paper, bg = colors.light.green_dark } },
			},
			lualine_x = {
				{ "encoding", color = { fg = colors.light.paper, bg = colors.light.green } },
				{ "fileformat", color = { fg = colors.light.paper, bg = colors.light.green } },
				{ "filetype", separator = { right = "" }, color = { fg = colors.light.paper, bg = colors.light.green_light } },
			},
			lualine_y = {
				{
					"progress",
					separator = { right = "▓▒░" },
					color = { fg = colors.light.navy, bg = colors.light.gold },
				},
			},
			lualine_z = {
				{ "location", separator = { right = "" }, left_padding = 2, color = { fg = colors.light.paper, bg = colors.light.blue } },
			},
		}
	end

	return {
		lualine_a = {
			{ "mode", separator = { left = "" }, right_padding = 2 },
		},
		lualine_b = {
			{
				"branch",
				separator = { left = "░▒▓", right = "" },
				color = { fg = colors.dark.white, bg = colors.dark.branch },
				fmt = function(str)
					if str == nil or str == "" then
						return " "
					end
					return str
				end,
			},
			{
				"diagnostics",
				symbols = { error = " ", warn = " ", info = " " },
				separator = { right = "" },
				color = { bg = colors.dark.diagnostics },
				diagnostics_color = {
					error = { fg = "#b7221e" },
					warn = { fg = "#ffc102" },
					info = { fg = "#27eedf" },
				},
				fmt = function(str)
					if str == nil or str == "" then
						return " "
					end
					return str
				end,
			},
		},
		lualine_c = { { "filename", path = 2, color = { fg = colors.dark.filename, bg = colors.dark.blue } } },
		lualine_x = {
			{ "encoding", color = { bg = colors.dark.blue } },
			{ "fileformat", color = { bg = colors.dark.blue } },
			{ "filetype", separator = { right = "" }, color = { bg = colors.dark.blue } },
		},
		lualine_y = {
			{
				"progress",
				separator = { right = "▓▒░" },
				color = { fg = colors.dark.filename, bg = colors.dark.darkblue },
			},
		},
		lualine_z = {
			{ "location", separator = { right = "" }, left_padding = 2 },
		},
	}
end

local inactive_sections = {
	lualine_a = {},
	lualine_b = { "filename" },
	lualine_c = {},
	lualine_x = { "location" },
	lualine_y = {},
	lualine_z = {},
}

local function current_mode()
	local theme_mode = require("saruDpol.theme_mode")
	return theme_mode.current_mode()
end

local function make_opts(mode)
	return {
		options = {
			icons_enabled = true,
			theme = build_theme(mode),
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
		sections = build_sections(mode),
		inactive_sections = inactive_sections,
		tabline = {},
		winbar = {},
		inactive_winbar = {},
		extensions = {},
		disabled_sections = {},
	}
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local group = vim.api.nvim_create_augroup("saru_lualine_theme_mode", { clear = true })

		local function refresh()
			lualine.setup(make_opts(current_mode()))
			vim.cmd("redrawstatus")
		end

		refresh()

		vim.api.nvim_create_autocmd("User", {
			group = group,
			pattern = "ThemeModeChanged",
			callback = refresh,
		})
	end,
}
