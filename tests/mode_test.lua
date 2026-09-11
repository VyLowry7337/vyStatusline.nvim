local mode = require("vyStatusline.mode")

local function test_hl_normal()
	assert(mode.hl("n") == "vyNormalMode")
	print("PASS: hl normal")
end

local function test_hl_visual()
	assert(mode.hl("v") == "vyVisualMode")
	print("PASS: hl visual")
end

local function test_hl_unknown()
	assert(mode.hl("xyz") == "vyNormalMode")
	print("PASS: hl unknown fallback")
end

local function test_get_special()
	local s = mode.get_special("snacks_picker_list")
	assert(s ~= nil, "should find snacks_picker_list")
	assert(s[1] == "EXPLORER", "label should be EXPLORER")
	assert(s[2] == "vyExplorerMode", "hl should be vyExplorerMode")
	print("PASS: get_special")
end

local function test_get_special_missing()
	assert(mode.get_special("nonexistent") == nil)
	print("PASS: get_special missing")
end

test_hl_normal()
test_hl_visual()
test_hl_unknown()
test_get_special()
test_get_special_missing()
