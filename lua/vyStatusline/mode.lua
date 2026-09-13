local M = {}

local NORMAL = "vyNormalMode"
local VISUAL = "vyVisualMode"
local SELECT = "vySelectMode"
local INSERT = "vyInsertMode"
local REPLACE = "vyReplaceMode"
local COMMAND = "vyCommandMode"
local CONFIRM = "vyConfirmMode"
local TERMINAL = "vyTerminalMode"
local TERMINAL_OFF = "vyNTerminalMode"

M.modes = {
	["n"] = { " ", NORMAL, "" },
	["niI"] = { " ", NORMAL, "" },
	["niR"] = { " ", NORMAL, "" },
	["niV"] = { " ", NORMAL, "" },
	["nt"] = { " OFF", TERMINAL_OFF, "" },
	["ntT"] = { " OFF", TERMINAL_OFF, "" },

	["no"] = { " ", NORMAL, "" },
	["nov"] = { " ", NORMAL, "" },
	["noV"] = { " ", NORMAL, "" },
	["no\22"] = { " ", NORMAL, "" },

	["v"] = { " ", VISUAL, "" },
	["vs"] = { " ", VISUAL, "" },
	["V"] = { " ", VISUAL, "" },
	["Vs"] = { " ", VISUAL, "" },
	["\22"] = { " ", VISUAL, "" },
	["\22s"] = { " ", VISUAL, "" },

	["s"] = { " ", SELECT, "" },
	["S"] = { " ", SELECT, "" },
	["\19"] = { " ", SELECT, "" },

	["i"] = { " ", INSERT, "" },
	["ic"] = { " ", INSERT, "" },
	["ix"] = { " ", INSERT, "" },

	["R"] = { " ", REPLACE, "" },
	["Rc"] = { " ", REPLACE, "" },
	["Rx"] = { " ", REPLACE, "" },
	["Rv"] = { " ", REPLACE, "" },
	["Rvc"] = { " ", REPLACE, "" },
	["Rvx"] = { " ", REPLACE, "" },

	["c"] = { " ", COMMAND, "" },
	["cv"] = { " ", COMMAND, "" },
	["ce"] = { " ", COMMAND, "" },

	["r"] = { " ", CONFIRM, "" },
	["rm"] = { " ", CONFIRM, "" },
	["r?"] = { " ", CONFIRM, "" },
	["x"] = { " ", CONFIRM, "" },

	["t"] = { " ", TERMINAL, "" },
	["!"] = { " ", TERMINAL, "" },
}

M.special = {
	["snacks_picker_list"] = { " ", "vyExplorerMode", "" },
	["lazygit"] = { "󰒲 ", "vyLazyGitMode", "" },
	["lazy"] = { "󰒲 ", "vyLazyNvimMode", "" },
	["qf"] = { "QF", "vyLazyNvimMode", "" },
}

function M.get(mode_key)
	return M.modes[mode_key]
end

function M.get_special(filetype)
	return M.special[filetype]
end

function M.hl(mode_key)
	local m = M.modes[mode_key]
	return m and m[2] or NORMAL
end

function M.icon(mode_key)
	local m = M.modes[mode_key]
	return m and m[3] or ""
end

return M
