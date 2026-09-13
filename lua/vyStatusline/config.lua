local M = {}

M.defaults = {
	order = {
		"mode",
		"filetype",
		"git_branch",
		"git_diff",
		"spacer",
		"lsp_progress",
		"diagnostics",
		"spacer",
		"lsp",
		"cwd",
		-- "cursor",
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

	local function apply_highlights()
		local hl = {
			-- Statusline segments
			StatusLine = { bg = colors.none, fg = colors.fg },
			StatusLineNC = { bg = colors.none, fg = colors.steel },
			vyFile = { bg = colors.none, fg = colors.fg },
			vyGitIcon = { bg = colors.none, fg = colors.purple },
			vyGitText = { bg = colors.none, fg = colors.purple },
			vyLspError = { bg = colors.none, fg = colors.rose },
			vyLspWarning = { bg = colors.none, fg = colors.gold },
			vyLspHints = { bg = colors.none, fg = colors.teal },
			vyLspInfo = { bg = colors.none, fg = colors.steel },
			vyCursorIcon = { bg = colors.none, fg = colors.peach },
			vyCursorText = { bg = colors.none, fg = colors.fg },
			vyLspIcon = { bg = colors.none, fg = colors.peach },
			vyLspText = { bg = colors.none, fg = colors.fg },
			vyCwdIcon = { bg = colors.none, fg = colors.cyan },
			vyCwdText = { bg = colors.none, fg = colors.fg },
			vyLspProgress = { bg = colors.none, fg = colors.rose, italic = true, bold = true },
			vySpacer = { link = "StatusLine" },
			vySep = { link = "StatusLine" },
			-- Mode highlights (linked to universal groups)
			vyNormalMode = { bg = colors.none, fg = colors.sage, bold = true },
			vyInsertMode = { bg = colors.none, fg = colors.purple, bold = true },
			vyVisualMode = { bg = colors.none, fg = colors.steel, bold = true },
			vyCommandMode = { bg = colors.none, fg = colors.peach, bold = true },
			vySelectMode = { bg = colors.none, fg = colors.steel, bold = true },
			vyReplaceMode = { bg = colors.none, fg = colors.peach, bold = true },
			vyTerminalMode = { bg = colors.none, fg = colors.cyan, bold = true },
			vyConfirmMode = { bg = colors.none, fg = colors.cyan, bold = true },
			vyNTerminalMode = { bg = colors.none, fg = colors.sage, bold = true },
			-- Special mode highlights
			vyExplorerMode = { bg = colors.none, fg = colors.rose, bold = true },
			vyLazyGitMode = { bg = colors.none, fg = colors.purple, bold = true },
			vyLazyNvimMode = { bg = colors.none, fg = colors.steel, bold = true },
		}

		for name, opts in pairs(hl) do
			vim.api.nvim_set_hl(0, name, opts)
		end
	end

	apply_highlights()

	-- Aucmd to reset colors on theme change
	vim.api.nvim_create_augroup("vyStatuslineColors", { clear = true })
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = "vyStatuslineColors",
		pattern = "*",
		callback = function()
			apply_highlights()
		end,
	})
end

function M.get()
	return M.opts or M.defaults
end

return M
