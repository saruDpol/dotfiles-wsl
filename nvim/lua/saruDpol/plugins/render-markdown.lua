return {
	{
		"ducks/mdpreview.nvim",
		ft = "markdown",
		cmd = {
			"MDPreview",
			"MDPreviewClose",
			"MDPreviewToggle",
		},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{
				"<leader>mp",
				"<cmd>MDPreviewToggle<cr>",
				desc = "Markdown preview split",
			},
		},
		config = function()
			require("mdpreview").setup()
		end,
	},
}
