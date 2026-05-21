return {
	"hrsh7th/cmp-nvim-lsp",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"neovim/nvim-lspconfig",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
			severity_sort = true,
		})

		if not (vim.lsp and vim.lsp.config and vim.lsp.enable) then
			vim.schedule(function()
				vim.notify("Neovim version too old for vim.lsp.config/vim.lsp.enable", vim.log.levels.ERROR)
			end)
			return
		end

		local js_ts_root = { "tsconfig.json", "jsconfig.json", "package.json", ".git" }

		vim.lsp.config("*", { capabilities = capabilities })
		vim.lsp.config("lua_ls", {
			settings = { Lua = { diagnostics = { globals = { "vim" } } } },
		})
		vim.lsp.config("ts_ls", { root_markers = js_ts_root })
		vim.lsp.config("eslint", { root_markers = js_ts_root })
		vim.lsp.config("html", { root_markers = js_ts_root })
		vim.lsp.config("cssls", { root_markers = js_ts_root })

		vim.lsp.enable({ "lua_ls", "pyright", "ts_ls", "eslint", "html", "cssls" })
	end,
}
