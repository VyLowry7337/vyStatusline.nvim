local M = {}

M.defaults = {
	order = {
		"mode",
		"filetype",
		"git_branch",
		"git_diff",
		"spacer",
		"lsp_progress",
		"spacer",
		"lsp",
		"diagnostics",
		"cwd",
		"cursor",
	},
}

M.opts = nil

function M.setup(user_config)
	local merged = vim.tbl_deep_extend("force", M.defaults, user_config or {})

	-- Replace order entirely if user provided one (don't deep-extend arrays)
	if user_config and user_config.order then
		merged.order = user_config.order
	end

	M.opts = merged

	local colors = {
		bg = "#0E1018",
		fg = "#C8D0E0",
		cyan = "#80C8E0",
		purple = "#B0A0D8",
		sage = "#90C8A0",
		peach = "#D0A888",
		gold = "#D4B878",
		rose = "#D0909C",
		teal = "#78B8B0",
		steel = "#8898B8",
		none = "none",
	}

	local hl = {
		-- Statusline segments
		StatusLine = { bg = colors.none, fg = colors.fg, default = true },
		StatusLineNC = { bg = colors.none, fg = colors.steel, default = true },
		vyFile = { bg = colors.none, fg = colors.fg, default = true },
		vyGitIcon = { bg = colors.none, fg = colors.purple, default = true },
		vyGitText = { bg = colors.none, fg = colors.purple, default = true },
		vyLspError = { bg = colors.none, fg = colors.rose, default = true },
		vyLspWarning = { bg = colors.none, fg = colors.gold, default = true },
		vyLspHints = { bg = colors.none, fg = colors.teal, default = true },
		vyLspInfo = { bg = colors.none, fg = colors.steel, default = true },
		vyCursorIcon = { bg = colors.none, fg = colors.peach, default = true },
		vyCursorText = { bg = colors.none, fg = colors.fg, default = true },
		vyLspIcon = { bg = colors.none, fg = colors.peach, default = true },
		vyLspText = { bg = colors.none, fg = colors.fg, default = true },
		vyCwdIcon = { bg = colors.none, fg = colors.cyan, default = true },
		vyCwdText = { bg = colors.none, fg = colors.fg, default = true },
		vyLspProgress = { bg = colors.none, fg = colors.rose, italic = true, bold = true, default = true },
		vySpacer = { link = "StatusLine", default = true },
		vySep = { link = "StatusLine", default = true },
		-- Mode highlights (linked to universal groups)
		vyNormalMode = { bg = colors.none, fg = colors.sage, bold = true, default = true },
		vyInsertMode = { bg = colors.none, fg = colors.purple, bold = true, default = true },
		vyVisualMode = { bg = colors.none, fg = colors.steel, bold = true, default = true },
		vyCommandMode = { bg = colors.none, fg = colors.peach, bold = true, default = true },
		vySelectMode = { bg = colors.none, fg = colors.steel, bold = true, default = true },
		vyReplaceMode = { bg = colors.none, fg = colors.peach, bold = true, default = true },
		vyTerminalMode = { bg = colors.none, fg = colors.cyan, bold = true, default = true },
		vyConfirmMode = { bg = colors.none, fg = colors.cyan, bold = true, default = true },
		vyNTerminalMode = { bg = colors.none, fg = colors.sage, bold = true, default = true },
		-- Special mode highlights
		vyExplorerMode = { bg = colors.none, fg = colors.rose, bold = true, default = true },
		vyLazyGitMode = { bg = colors.none, fg = colors.purple, bold = true, default = true },
		vyLazyNvimMode = { bg = colors.none, fg = colors.steel, bold = true, default = true },
	}

	for name, opts in pairs(hl) do
		vim.api.nvim_set_hl(0, name, opts)
	end
end

function M.get()
	return M.opts or M.defaults
end

return M
