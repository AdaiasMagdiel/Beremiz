local root_path = debug.getinfo(1, "S").source:sub(2):match("(.*[\\/])")
package.path = ("%s;%s?.lua"):format(package.path, root_path)

local pprint = require("lib.pprint")

local Parser = require('src.parser')
local Lexer = require("src.lexer")


local name = "Beremiz"
local copyright = "Copyright (C) 2024 Adaías Magdiel"

local usage = [[
Usage: lua main.lua [file]

Arguments:
    file        Optional. Beremiz code to run.
]]

local function runPrompt()
	print(("%s  %s"):format(name, copyright))

	while true do
		io.write('> ')
		local input = io.read()

		if input == nil then
			break
		end

		local lexer = Lexer:new("stdin", input)
		local tokens = lexer:scan()

		local parser = Parser:new(tokens, input)
		parser:parse()
	end
end

local function runFile(filepath)
	local file = io.open(filepath, 'r')

	if file == nil then
		print('Error: unable to open file.')
		os.exit(1)
	end

	local content = file:read('*a')
	file:close()

	local lexer = Lexer:new(filepath, content)
	local tokens = lexer:scan()

	local parser = Parser:new(tokens, content)
	parser:parse()
end

local function main()
	if #arg == 0 then
		runPrompt()
	elseif #arg == 1 then
		runFile(arg[1])
	else
		print(usage)
	end
end
main()
