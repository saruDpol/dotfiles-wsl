local paste = {
	"powershell.exe",
	"-NoLogo",
	"-NoProfile",
	"-Command",
	'[Console]::Out.Write((Get-Clipboard -Raw).ToString().Replace("`r", ""))',
}

vim.g.clipboard = {
	name = "WslClipboard",
	copy = {
		["+"] = { "clip.exe" },
		["*"] = { "clip.exe" },
	},
	paste = {
		["+"] = paste,
		["*"] = paste,
	},
	cache_enabled = 0,
}

vim.opt.clipboard = "unnamedplus"
