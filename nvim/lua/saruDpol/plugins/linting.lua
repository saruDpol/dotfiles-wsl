return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		-- Use Ruff for Python
		lint.linters_by_ft = {
			python = { "ruff" },
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
			if vim.bo.filetype ~= "python" then
				return
			end

			-- Only run if a venv is selected
			if not vim.g.current_venv then
				return
			end

			-- Activate the current venv
			vim.fn["venv-selector#activate"](vim.g.current_venv)

			local linters = lint.linters_by_ft[vim.bo.filetype]
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
