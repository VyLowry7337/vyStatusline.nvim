-- if-statusline/plugin/statusline.lua
-- Auto-setup: only runs if user hasn't called setup() yet
if vim.g.loaded_vyStatusline then
	return
end
vim.g.loaded_vyStatusline = true

vim.api.nvim_create_autocmd("User", {
	pattern = "DeferredLoaded",
	once = true,
	callback = function()
		local ok, statusline = pcall(require, "vyStatusline")
		if ok and not require("vyStatusline.config").opts then
			statusline.setup()
		end
	end,
})
