local config = require("vyStatusline.config")

local function test_defaults()
	config.setup()
	local opts = config.get()
	assert(type(opts.order) == "table", "order should be a table")
	assert(#opts.order == 10, "default order should have 10 segments")
	assert(opts.order[1] == "filetype", "first segment should be filetype")
	print("PASS: defaults")
end

local function test_custom_order()
	config.setup({ order = { "mode", "file", "cursor" } })
	local opts = config.get()
	assert(#opts.order == 3, "custom order should have 3 segments")
	assert(opts.order[1] == "mode", "first segment should be mode")
	print("PASS: custom order")
end

test_defaults()
test_custom_order()
