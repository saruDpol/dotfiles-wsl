return {
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = false,
		priority = 1000,
		opts = { transparent = true },
		config = function(_, opts)
			require("solarized-osaka").setup(opts)
			vim.cmd.colorscheme("solarized-osaka")
		end,
	},
}

-- return {
-- 	{
-- 		"rose-pine/neovim",
-- 		name = "rose-pine",
-- 		lazy = false,
-- 		priority = 1000,
-- 		opts = {
-- 			variant = "auto", -- auto, main, moon, or dawn
-- 			dark_variant = "main",
-- 			disable_background = true,
-- 			disable_float_background = true,
-- 			highlight_groups = {
-- 				-- You can customize highlights here
-- 				-- Example:
-- 				-- ColorColumn = { bg = "rose" },
-- 			},
-- 		},
-- 		config = function(_, opts)
-- 			require("rose-pine").setup(opts)
-- 			vim.cmd.colorscheme("rose-pine")
-- 		end,
-- 	},
-- }
