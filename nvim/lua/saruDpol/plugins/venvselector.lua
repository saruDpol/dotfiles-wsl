-- return {
-- 	{
-- 		"linux-cultist/venv-selector.nvim",
-- 		event = { "BufReadPre", "BufNewFile" },
-- 		config = function()
-- 			require("venv-selector").setup({
-- 				name = ".venv", -- venv folder to detect
-- 				default = vim.fn.exepath("python3"), -- fallback python if no venv
-- 			})
--
-- 			-- Optional keymap to manually select a venv
-- 			vim.keymap.set("n", ";v", ":VenvSelect<CR>", { desc = "Select Python venv for this project" })
-- 		end,
-- 	},
-- }
--
local function find_venv(start_dir)
	local uv = vim.loop
	local dir = start_dir or vim.fn.getcwd()

	while dir and dir ~= "" do
		local venv_path = dir .. "/.venv"
		local py_exe

		-- Check Linux/WSL
		py_exe = venv_path .. "/bin/python"
		if vim.fn.filereadable(py_exe) == 1 then
			return py_exe
		end

		-- Check Windows
		py_exe = venv_path .. "\\Scripts\\python.exe"
		if vim.fn.filereadable(py_exe) == 1 then
			return py_exe
		end

		-- Go up one directory
		local parent = uv.fs_realpath(dir .. "/..")
		if parent == dir then
			break
		end
		dir = parent
	end

	-- fallback
	return vim.fn.exepath("python3")
end

return {
	{
		"linux-cultist/venv-selector.nvim",
		ft = "python",
		keys = {
			{ ";v", "<cmd>VenvSelect<CR>", desc = "Select Python virtual environment" },
		},
		config = function()
			local python_path = find_venv()
			require("venv-selector").setup({
				name = ".venv",
				options = {
					auto_activate = true,
				},
				custom_venvs = { python_path },
			})
		end,
	},
}
