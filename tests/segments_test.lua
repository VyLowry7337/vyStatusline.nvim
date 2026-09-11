local segments = require("vyStatusline.segments")

local function test_mode()
	local result = segments.mode()
	assert(type(result) == "string", "mode should return string")
	print("PASS: mode")
end

local function test_filetype()
	local result = segments.filetype()
	assert(type(result) == "string", "filetype should return string")
	print("PASS: filetype")
end

local function test_diagnostics()
	local result = segments.diagnostics()
	assert(type(result) == "string", "diagnostics should return string")
	print("PASS: diagnostics")
end

local function test_cursor()
	local result = segments.cursor()
	assert(type(result) == "string", "cursor should return string")
	assert(result:find("vyCursorIcon"), "cursor should contain icon highlight")
	print("PASS: cursor")
end

local function test_spacer()
	local result = segments.spacer()
	assert(result == "%=", "spacer should return %=")
	print("PASS: spacer")
end

local function test_git_branch()
	local result = segments.git_branch()
	assert(type(result) == "string", "git_branch should return string")
	print("PASS: git_branch")
end

local function test_lsp()
	local result = segments.lsp()
	assert(type(result) == "string", "lsp should return string")
	print("PASS: lsp")
end

local function test_cwd()
	local result = segments.cwd()
	assert(type(result) == "string", "cwd should return string")
	print("PASS: cwd")
end

test_mode()
test_filetype()
test_diagnostics()
test_cursor()
test_spacer()
test_git_branch()
test_lsp()
test_cwd()
