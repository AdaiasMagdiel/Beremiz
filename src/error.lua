local pprint = require("lib.pprint")
local Error = {}

function Error.splitLines(raw)
	local lines = {}

	for str in raw:gmatch("([^\n]*)\n?") do
	    table.insert(lines, str)
	end

	return lines
end

function Error.show(message, token, lines)
	io.write(
		("%s:%d:%d | %s\n\n")
		:format(token.loc.file, token.loc.line, token.loc.col, message)
	)

	local line = lines[token.loc.line]
	local space = "."
	local lineNum = token.loc.line
	local lineCol = token.loc.col
	local errorInfo = ("%d:%d | "):format(lineNum, lineCol)

	io.write(("%s%s\n"):format(errorInfo, line))
	io.write(
		(space):rep(#errorInfo + lineCol),
		"^",
		'\n'
	)

	os.exit(1)
end

return Error
