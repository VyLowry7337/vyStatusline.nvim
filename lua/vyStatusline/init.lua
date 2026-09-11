local M = {}
local segments = require("vyStatusline.segments")
local config = require("vyStatusline.config")

function M.generate()
	local winid = vim.g.statusline_winid
	if winid and vim.api.nvim_win_is_valid(winid) and vim.api.nvim_win_get_config(winid).relative ~= "" then
		return ""
	end
	local result = {}
	for _, v in ipairs(config.get().order) do
		local module = segments[v]
		if type(module) == "function" then
			local out = module()
			if out then
				table.insert(result, out)
			end
		elseif module then
			table.insert(result, module)
		else
			table.insert(result, v)
		end
	end
	return table.concat(result)
end

M.state = {
	active = false,
	title = "",
	message = "",
	percentage = nil,
}

local timer = nil

local function start_spinner()
	if timer then
		return
	end
	timer = vim.uv.new_timer()
	timer:start(
		0,
		80,
		vim.schedule_wrap(function()
			if not M.state.active then
				if timer then
					timer:stop()
					timer:close()
					timer = nil
				end
				vim.cmd.redrawstatus()
				return
			end
			vim.cmd.redrawstatus()
		end)
	)
end

local function stop_spinner()
	if timer then
		timer:stop()
		timer:close()
		timer = nil
	end
	vim.cmd.redrawstatus()
end

function M.setup(user_config)
	config.setup(user_config)

	local augroup = vim.api.nvim_create_augroup("vyStatusline", { clear = true })

	vim.o.statusline = "%!v:lua.require('vyStatusline').generate()"

	if vim.tbl_contains(config.get().order, "mode") then
		vim.api.nvim_create_autocmd("ModeChanged", {
			group = augroup,
			callback = function()
				vim.cmd.redrawstatus()
			end,
		})
	end

	vim.api.nvim_create_autocmd("LspDetach", {
		group = augroup,
		callback = function()
			if not next(vim.lsp.get_clients()) then
				M.state.active = false
				stop_spinner()
			end
		end,
	})

	vim.api.nvim_create_autocmd("LspProgress", {
		group = augroup,
		callback = function(args)
			if not args.data or not args.data.params then
				return
			end
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if client and client.name == "jdtls" then
				return
			end
			local data = args.data.params.value
			if data.kind == "end" then
				M.state.active = false
				M.state.title = ""
				M.state.message = ""
				M.state.percentage = nil
				stop_spinner()
			else
				M.state.active = true
				M.state.title = data.title or ""
				M.state.message = data.message or ""
				M.state.percentage = data.percentage
				start_spinner()
			end
		end,
	})
end

return M
