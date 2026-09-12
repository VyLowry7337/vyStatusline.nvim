local M = {}

M.defaults = {
	order = {
		"mode",
		"filetype",
		"lsp",
		"git_branch",
		"git_diff",
		"spacer",
		"lsp_progress",
		"spacer",
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

	local hl = {
		-- Statusline segments
		vyFileIcon = { link = "Directory", default = true },
		vyFile = { link = "Directory", default = true },
		vyGitIcon = { link = "Statement", default = true },
		vyGitText = { link = "Statement", default = true },
		vyLspError = { link = "DiagnosticError", default = true },
		vyLspWarning = { link = "DiagnosticWarn", default = true },
		vyLspHints = { link = "DiagnosticHint", default = true },
		vyLspInfo = { link = "DiagnosticInfo", default = true },
		vyCursorIcon = { link = "StatusLine", default = true },
		vyCursorText = { link = "StatusLine", default = true },
		vyLspIcon = { link = "Type", default = true },
		vyLspText = { link = "Type", default = true },
		vyCwdIcon = { link = "Comment", default = true },
		vyCwdText = { link = "Comment", default = true },
		vyLspProgress = { link = "Special", default = true },
		vySpacer = { link = "StatusLine", default = true },
		vySep = { link = "Comment", default = true },
		-- Mode highlights (linked to universal groups)
		vyNormalMode = { link = "Statement", default = true },
		vyInsertMode = { link = "String", default = true },
		vyVisualMode = { link = "Type", default = true },
		vyCommandMode = { link = "Constant", default = true },
		vySelectMode = { link = "Special", default = true },
		vyReplaceMode = { link = "Identifier", default = true },
		vyTerminalMode = { link = "Keyword", default = true },
		vyConfirmMode = { link = "Constant", default = true },
		vyNTerminalMode = { link = "Keyword", default = true },
		-- Special mode highlights
		vyExplorerMode = { link = "Statement", default = true },
		vyLazyGitMode = { link = "Statement", default = true },
		vyLazyNvimMode = { link = "Statement", default = true },
	}

	for name, opts in pairs(hl) do
		vim.api.nvim_set_hl(0, name, opts)
	end
end

function M.get()
	return M.opts or M.defaults
end

return M
