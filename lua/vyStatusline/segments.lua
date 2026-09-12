local M = {}
local mode = require("vyStatusline.mode")

local function drawn_window()
	return vim.g.statusline_winid or vim.api.nvim_get_current_win()
end

local function is_active_window()
	return vim.api.nvim_get_current_win() == drawn_window()
end

local function statusline_buf()
	return vim.api.nvim_win_get_buf(drawn_window())
end

local function render_mode(label, hl, icon)
	local icon_part = icon and (icon .. " ") or ""
	return "%#" .. hl .. "# " .. icon_part .. label .. " %*"
end

function M.mode()
	local buf = vim.api.nvim_get_current_buf()
	local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
	local m = vim.api.nvim_get_mode().mode

	if not is_active_window() then
		return ""
	end

	local special = mode.get_special(filetype)

	if special then
		return render_mode(special[1], special[2], special[3])
	end

	local current = mode.get(m)

	if current then
		return render_mode(current[1], current[2], current[3])
	end

	return ""
end

function M.filetype()
	local empty = ""
	local buf = vim.api.nvim_get_current_buf()
	local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })

	local function set_file_info(color, filetype_icon, ft)
		local icon = " 󰈚 "
		local existing = vim.api.nvim_get_hl(0, { name = "vyFileIcon" })
		vim.api.nvim_set_hl(0, "vyFileIcon", vim.tbl_extend("force", existing, { fg = color }))
		icon = "%#vyFileIcon#" .. " " .. filetype_icon

		ft = "%#vyFile#" .. " " .. ft

		if icon ~= "" then
			return icon .. ft .. " %*"
		end
	end

	if filetype == "" or filetype == nil or filetype == "terminal" then
		return empty
	end

	local has_devicons, devicons = pcall(require, "nvim-web-devicons")

	if not has_devicons then
		return empty
	end

	local filetype_icon, ft_color = devicons.get_icon_color_by_filetype(filetype)

	if filetype_icon and ft_color then
		return set_file_info(ft_color, filetype_icon, filetype)
	end

	local filename = vim.api.nvim_buf_get_name(buf)
	local fn_icon, fn_color = devicons.get_icon_color(filename)

	if fn_icon and fn_color then
		return set_file_info(fn_color, fn_icon, filetype)
	end

	return empty
end

function M.git_branch()
	if not vim.b[statusline_buf()].gitsigns_head or vim.b[statusline_buf()].gitsigns_git_status then
		return ""
	end

	local git_status = vim.b[statusline_buf()].gitsigns_status_dict
	local icon_hl = "%#vyGitIcon#"
	local text_hl = "%#vyGitText#"
	local branch_icon = ""
	local branch_name = git_status.head

	if branch_name == nil or branch_name == "" then
		return ""
	end

	return " " .. icon_hl .. branch_icon .. " " .. text_hl .. branch_name .. " %*"
end

function M.git_diff()
	local git_status = vim.b[statusline_buf()].gitsigns_status_dict
	if not git_status then
		return ""
	end

	local git_icon = {
		add = " ",
		change = " ",
		delete = " ",
	}

	local parts = {}
	if git_status.added and git_status.added > 0 then
		table.insert(parts, string.format("%%#GitSignsAdd#%s %d", git_icon.add, git_status.added))
	end
	if git_status.changed and git_status.changed > 0 then
		table.insert(parts, string.format("%%#GitSignsChange#%s %d", git_icon.change, git_status.changed))
	end
	if git_status.removed and git_status.removed > 0 then
		table.insert(parts, string.format("%%#GitSignsDelete#%s %d", git_icon.delete, git_status.removed))
	end

	if #parts == 0 then
		return ""
	end

	return "%*[" .. table.concat(parts, " ") .. "%*] %*"
end

function M.diagnostics()
	if not vim.lsp then
		return ""
	end

	local errors = #vim.diagnostic.get(statusline_buf(), { severity = vim.diagnostic.severity.ERROR })
	local warnings = #vim.diagnostic.get(statusline_buf(), { severity = vim.diagnostic.severity.WARN })
	local hints = #vim.diagnostic.get(statusline_buf(), { severity = vim.diagnostic.severity.HINT })
	local info = #vim.diagnostic.get(statusline_buf(), { severity = vim.diagnostic.severity.INFO })

	local error_text = (errors and errors > 0) and ("%#vyLspError#" .. " " .. errors .. " ") or ""
	local warning_text = (warnings and warnings > 0) and ("%#vyLspWarning#" .. " " .. warnings .. " ") or ""
	local hint_text = (hints and hints > 0) and ("%#vyLspHints#" .. "󰛩 " .. hints .. " ") or ""
	local info_text = (info and info > 0) and ("%#vyLspInfo#" .. "󰋼 " .. info .. " ") or ""

	return error_text .. warning_text .. hint_text .. info_text .. " %*"
end

function M.cursor()
	local current_line = vim.fn.line(".")
	local current_column = vim.fn.col(".")

	local line_text = "" .. current_line
	local colmn_text = "" .. current_column

	local icon = "%#vyCursorIcon#" .. "  "
	local text = "%#vyCursorText#" .. line_text .. ":" .. colmn_text
	return icon .. text .. " %*"
end

function M.lsp()
	if not vim.lsp then
		return ""
	end

	local clients = vim.lsp.get_clients()

	for _, client in ipairs(clients) do
		local current_buf = vim.api.nvim_get_current_buf()

		if
			client.attached_buffers[current_buf]
			and client.name ~= "eslint"
			and client.name ~= "tailwindcss"
			and client.name ~= "biome"
		then
			local lsp_icon = "%#vyLspIcon#" .. " 󱤓 "
			local lsp_text = "%#vyLspText#" .. client.name

			return lsp_icon .. lsp_text .. " %*"
		end
	end

	return ""
end

function M.cwd()
	local name = vim.uv.cwd()
	if not name then
		return ""
	end
	name = vim.fs.basename(name) or name
	if vim.o.columns <= 85 then
		return ""
	end
	return "%#vyCwdIcon# 󰉋 %#vyCwdText#" .. name .. " %*"
end

function M.lsp_progress()
	local stl = require("vyStatusline")
	if not stl.state.active or vim.o.columns < 120 then
		return ""
	end

	local progress_frames = {
		"▰▱▱▱▱▱▱ ",
		"▰▰▱▱▱▱▱ ",
		"▰▰▰▱▱▱▱ ",
		"▰▰▰▰▱▱▱ ",
		"▰▰▰▰▰▱▱ ",
		"▰▰▰▰▰▰▱ ",
		"▰▰▰▰▰▰▰ ",
		"▰▱▱▱▱▱▱ ",
		-- "✶",
		-- "✸",
		-- "✹",
		-- "✺",
		-- "✹",
		-- "✷",
	}
	local ms = vim.uv.hrtime() / 1000000
	local frame = math.floor(ms / 120) % #progress_frames
	local icon = progress_frames[frame + 1]

	local parts = {}
	if stl.state.percentage then
		table.insert(parts, stl.state.percentage .. "%%")
	end
	if stl.state.title ~= "" then
		table.insert(parts, stl.state.title)
	end
	local msg = stl.state.message:match("^(%d+/%d+)") or ""
	if msg ~= "" then
		table.insert(parts, msg)
	end

	local content = icon .. " " .. table.concat(parts, " ")
	return "%#vyLspProgress# " .. content .. " %*"
end

function M.spacer()
	return "%="
end

return M
