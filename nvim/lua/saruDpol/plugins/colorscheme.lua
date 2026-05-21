return {
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true,
		},
		config = function(_, opts)
			require("solarized-osaka").setup(opts)
			local theme_mode = require("saruDpol.theme_mode")
			theme_mode.apply(true)
			theme_mode.setup_autocmd()
		end,
	},
	{
		"savq/melange-nvim",
		lazy = false,
		priority = 1000,
	},
}
