local statusline = require("vyStatusline")

local function test_setup()
	statusline.setup()
	assert(vim.o.statusline ~= "", "statusline should be set")
	print("PASS: setup")
end

local function test_generate()
	local result = statusline.generate()
	assert(type(result) == "string", "generate should return string")
	assert(#result > 0, "generate should return non-empty string")
	print("PASS: generate")
end

local function test_state()
	assert(type(statusline.state) == "table", "state should be a table")
	assert(statusline.state.active == false, "state.active should default false")
	print("PASS: state")
end

test_setup()
test_generate()
test_state()
