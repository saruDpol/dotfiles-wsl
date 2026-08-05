return {
	"kdheepak/lazygit.nvim",

	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},

	dependencies = {
		"nvim-lua/plenary.nvim",
	},

	keys = {
		{
			"<leader>gg",
			"<cmd>LazyGit<cr>",
			desc = "LazyGit: repositori actual",
		},
		{
			"<leader>gr",
			"<cmd>LazyGitCurrentFile<cr>",
			desc = "LazyGit: repositori del fitxer actual",
		},
		{
			"<leader>gl",
			"<cmd>LazyGitFilter<cr>",
			desc = "LazyGit: historial de commits",
		},
		{
			"<leader>gL",
			"<cmd>LazyGitFilterCurrentFile<cr>",
			desc = "LazyGit: historial del fitxer",
		},
		{
			"<leader>gC",
			"<cmd>LazyGitConfig<cr>",
			desc = "LazyGit: configuraci¢",
		},
	},

	init = function()
		-- Finestra opaca: no es veu el contingut de darrere.
		vim.g.lazygit_floating_window_winblend = 0

		-- Mida de la finestra.
		vim.g.lazygit_floating_window_scaling_factor = 0.92

		-- Vora invisible i minimalista.
		vim.g.lazygit_floating_window_border_chars = {
			" ",
			" ",
			" ",
			" ",
			" ",
			" ",
			" ",
			" ",
		}

		-- Evita que Plenary modifiqui l'aparen‡a de la finestra.
		vim.g.lazygit_floating_window_use_plenary = 0

		vim.g.lazygit_use_neovim_remote = 0
	end,
}
