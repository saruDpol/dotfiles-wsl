local M = {}

local mode_file = vim.env.THEME_MODE_FILE or ((vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")) .. "/theme-mode")
local last_mode = nil

local function read_mode()
	local f = io.open(mode_file, "r")
	if not f then
		return "dark"
	end
	local value = f:read("*l")
	f:close()
	if value == "light" then
		return "light"
	end
	return "dark"
end

function M.apply(force)
	local mode = read_mode()
	if not force and mode == last_mode then
		return
	end
	last_mode = mode

	if mode == "light" then
		local ok = pcall(vim.cmd.colorscheme, "melange")
		if not ok then
			pcall(vim.cmd.colorscheme, "solarized-osaka")
		end
		return
	end

	pcall(vim.cmd.colorscheme, "solarized-osaka")
end

function M.setup_autocmd()
	local group = vim.api.nvim_create_augroup("saru_theme_mode_sync", { clear = true })
	vim.api.nvim_create_autocmd({ "VimEnter", "FocusGained", "BufEnter" }, {
		group = group,
		callback = function()
			M.apply(false)
		end,
	})
end

return M
