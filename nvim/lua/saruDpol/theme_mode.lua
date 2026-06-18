local M = {}

local mode_file = (vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")) .. "/theme-mode"
local last_mode = nil
local poll_timer = nil
local last_mtime = nil

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

local function file_mtime()
	local stat = vim.uv.fs_stat(mode_file)
	if not stat or not stat.mtime then
		return nil
	end
	return stat.mtime.sec
end

local function ensure_mode_file()
	local dir = vim.fs.dirname(mode_file)
	if dir then
		vim.fn.mkdir(dir, "p")
	end

	if vim.uv.fs_stat(mode_file) then
		return
	end

	local fd = assert(vim.uv.fs_open(mode_file, "w", 420))
	vim.uv.fs_write(fd, "dark\n", -1)
	vim.uv.fs_close(fd)
end

function M.apply(force)
	local mode = read_mode()
	if not force and mode == last_mode then
		return
	end
	last_mode = mode

	if mode == "light" then
		vim.o.background = "light"
		local ok = pcall(vim.cmd.colorscheme, "kanagawa-lotus")
		if not ok then
			ok = pcall(vim.cmd.colorscheme, "solarized-osaka-day")
		end
		if not ok then
			pcall(vim.cmd.colorscheme, "melange")
		end
	else
		vim.o.background = "dark"
		pcall(vim.cmd.colorscheme, "solarized-osaka")
	end

	if mode == "light" then
		local hl = vim.api.nvim_set_hl
		hl(0, "CursorLine", { bg = "#d2ddc5" })
		hl(0, "SignColumn", { bg = "NONE" })
		hl(0, "LineNr", { bg = "NONE" })
		hl(0, "CursorLineNr", { fg = "#d498a3", bg = "NONE", bold = true })
		hl(0, "FoldColumn", { bg = "NONE" })
		hl(0, "EndOfBuffer", { bg = "NONE" })
	end

	pcall(
		vim.api.nvim_exec_autocmds,
		"User",
		{ pattern = "ThemeModeChanged", modeline = false, data = { mode = mode } }
	)
end

function M.current_mode()
	return read_mode()
end

function M.set_mode(mode)
	if mode ~= "dark" and mode ~= "light" then
		vim.notify("Theme mode must be 'dark' or 'light'", vim.log.levels.ERROR)
		return
	end

	ensure_mode_file()
	local fd = assert(vim.uv.fs_open(mode_file, "w", 420))
	vim.uv.fs_write(fd, mode .. "\n", -1)
	vim.uv.fs_close(fd)
	last_mtime = file_mtime()
	M.apply(true)
end

function M.toggle()
	if read_mode() == "dark" then
		M.set_mode("light")
		return
	end
	M.set_mode("dark")
end

function M.setup()
	local group = vim.api.nvim_create_augroup("saru_theme_mode_sync", { clear = true })
	ensure_mode_file()
	last_mtime = file_mtime()

	vim.api.nvim_create_autocmd({ "VimEnter", "FocusGained", "BufEnter" }, {
		group = group,
		callback = function()
			M.apply(false)
		end,
	})

	vim.api.nvim_create_user_command("Theme", function(opts)
		local arg = opts.args
		if arg == "toggle" then
			M.toggle()
			return
		end

		M.set_mode(arg)
	end, {
		nargs = 1,
		complete = function()
			return { "dark", "light", "toggle" }
		end,
	})

	if poll_timer then
		poll_timer:stop()
		poll_timer:close()
	end

	poll_timer = vim.uv.new_timer()
	if poll_timer then
		poll_timer:start(
			0,
			700,
			vim.schedule_wrap(function()
				local mtime = file_mtime()
				if mtime == nil or mtime == last_mtime then
					return
				end

				last_mtime = mtime
				M.apply(true)
			end)
		)
	end

	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = group,
		callback = function()
			if poll_timer then
				poll_timer:stop()
				poll_timer:close()
				poll_timer = nil
			end
		end,
	})
end

return M
