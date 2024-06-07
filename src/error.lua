local pprint = require("lib.pprint")
local Error = {}

local function getNextSpace(actualCol, line)
	local col = actualCol+1

	while true do
		if col > #line then
			break
		end

		if line:sub(col,  col) == " " then
			break
		end

		col = col+1
	end

	return col
end

function Error.splitLines(raw)
	local lines = {}

	for str in raw:gmatch("([^\n]*)\n?") do
	    table.insert(lines, str)
	end

	return lines
end

function Error.show(message, token, lines)
	io.write(
		("\x1b[31m%s:%d:%d\x1b[0m | %s\n\n")
		:format(token.loc.file, token.loc.line, token.loc.col, message)
	)

	local line = lines[token.loc.line]
	local space = " "
	local lineNum = token.loc.line
	local lineCol = token.loc.col
	local errorInfo = ("\x1b[31m%d:%d\x1b[0m | "):format(lineNum, lineCol)

	local offset = 6

	local nextSpaceCol = getNextSpace(lineCol, line)
	local under = ("~"):rep(#tostring(token.value or "_"))

	io.write(("%s%s\n"):format(errorInfo, line))
	io.write(
		space:rep(lineCol-1 + offset),
		("\x1b[31m^%s\x1b[0m"):format(under),
		'\n'
	)

	os.exit(1)
end

return Error
