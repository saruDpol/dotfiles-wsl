return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")
			local install_dir = vim.fn.stdpath("data") .. "/site"
			local parsers = {
				"bash",
				"c",
				"css",
				"dockerfile",
				"gitignore",
				"graphql",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			}

			ts.setup({
				install_dir = install_dir,
			})

			vim.treesitter.language.register("bash", "zsh")

			local installed = {}
			for _, lang in ipairs(ts.get_installed("parsers")) do
				installed[lang] = true
			end

			local missing = vim.tbl_filter(function(lang)
				return not installed[lang]
			end, parsers)

			if #missing > 0 then
				ts.install(missing)
			end
		end,
	},
}
