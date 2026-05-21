return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		-- Use Ruff for Python
		lint.linters_by_ft = {
			python = { "ruff" },
			javascript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescript = { "eslint_d" },
			typescriptreact = { "eslint_d" },
		}

		-- Create autocmd group for linting
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		-- Function to sort diagnostics by severity (errors first)
		local function sort_diagnostics_by_severity(diagnostics)
			table.sort(diagnostics, function(a, b)
				return a.severity < b.severity
			end)
			return diagnostics
		end

		-- Function to trigger linting with venv activated
		local function try_linting()
			local ft = vim.bo.filetype
			if ft == "python" then
				-- Only run Python linting if a venv is selected
				if not vim.g.current_venv then
					return
				end
				vim.fn["venv-selector#activate"](vim.g.current_venv)
			end

			local linters = lint.linters_by_ft[ft]
			if not linters then
				return
			end

			local diagnostics = lint.try_lint(linters)

			if diagnostics then
				for bufnr, diags in pairs(diagnostics) do
					vim.diagnostic.set(
						vim.api.nvim_create_namespace("nvim-lint"),
						bufnr,
						sort_diagnostics_by_severity(diags),
						{}
					)
				end
			end
		end

		-- Auto-lint on buffer enter, write, and leaving insert mode
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = try_linting,
		})

		-- Keymap to manually trigger linting
		vim.keymap.set("n", "<leader>l", try_linting, { desc = "Trigger linting for current file" })
	end,
}
