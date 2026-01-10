-- return {
-- 	"williamboman/mason.nvim",
-- 	dependencies = {
-- 		"williamboman/mason-lspconfig.nvim",
-- 		"WhoIsSethDaniel/mason-tool-installer.nvim",
-- 	},
-- 	config = function()
-- 		-- import mason
-- 		local mason = require("mason")
--
-- 		-- import mason-lspconfig
-- 		local mason_lspconfig = require("mason-lspconfig")
--
-- 		local mason_tool_installer = require("mason-tool-installer")
--
-- 		-- enable mason and configure icons
-- 		mason.setup({
-- 			ui = {
-- 				icons = {
-- 					package_installed = "✓",
-- 					package_pending = "➜",
-- 					package_uninstalled = "✗",
-- 				},
-- 			},
-- 		})
--
-- 		mason_lspconfig.setup({
-- 			-- list of servers for mason to install
-- 			ensure_installed = {
-- 				"html",
-- 				"cssls",
-- 				"tailwindcss",
-- 				"ts_ls",
-- 				"svelte",
-- 				"lua_ls",
-- 				"graphql",
-- 				"emmet_ls",
-- 				"prismals",
-- 				"pyright",
-- 				"eslint",
-- 			},
-- 		})
--
-- 		mason_tool_installer.setup({
-- 			ensure_installed = {
-- 				"prettier", -- prettier formatter
-- 				"stylua", -- lua formatter
-- 				"isort", -- python formatter
-- 				"black", -- python formatter
-- 				"pylint",
-- 				"eslint_d",
-- 			},
-- 		})
-- 	end,
-- }
--
return {
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			-- 🧠 LSP servers Mason should install automatically
			ensure_installed = {
				"lua_ls", -- Lua
				"pyright", -- Python
				"ts_ls", -- TypeScript / React / React Native
				"eslint", -- JS/TS linting
				"html", -- for JSX/HTML support
				"cssls", -- for styled-components, inline styles, etc.
			},
		},
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				},
			},
			"neovim/nvim-lspconfig", -- required for vim.lsp.config
		},
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			-- 🧹 Formatters, linters, and extra tools
			ensure_installed = {
				"prettier", -- JS / TS / React formatter
				"stylua", -- Lua formatter
				"isort", -- Python import sorter
				"black", -- Python formatter
				"pylint", -- Python linter
				"eslint_d", -- Fast JS / TS linter
			},
		},
		dependencies = { "williamboman/mason.nvim" },
	},
}
