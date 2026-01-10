return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	event = "VeryLazy",
	keys = {
		{ "te", "<Cmd>tabnew<CR>", desc = "New tab" },
		{ "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
		{ "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
	},
	config = function()
		require("bufferline").setup({
			options = {
				mode = "tabs",
				show_buffer_close_icons = false,
				show_close_icon = false,
				separator_style = "thin",
				always_show_bufferline = false,
				color_icons = false,
				themable = true,
			},
			highlights = {
				fill = {
					bg = "none",
				},
				background = {
					fg = "#586e75",
					bg = "none",
				},
				tab = {
					fg = "#586e75",
					bg = "none",
				},
				tab_selected = {
					fg = "#b58900", -- Solarized Osaka gold
					bg = "none",
					bold = true,
				},
				tab_separator = {
					fg = "none",
					bg = "none",
				},
				tab_separator_selected = {
					fg = "none",
					bg = "none",
				},
			},
		})

		-- Forcefully override any lingering separator highlight groups
		local hl = vim.api.nvim_set_hl
		hl(0, "BufferLineTabSeparator", { fg = "NONE", bg = "NONE" })
		hl(0, "BufferLineTabSeparatorSelected", { fg = "NONE", bg = "NONE" })
		hl(0, "TabLine", { fg = "#586e75", bg = "NONE" })
		hl(0, "TabLineSel", { fg = "#b58900", bg = "NONE", bold = true })
		hl(0, "TabLineFill", { bg = "NONE" })
	end,
}
