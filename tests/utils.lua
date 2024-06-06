local Utils = {}

function Utils.exec(command)
	local fp = io.popen(command, "r")

	if fp == nil then
		print("Error: Unable to run command.")
		os.exit(1)
	end

	local content = fp:read("*a")

	fp:close()

	return content:gsub("^%s*(.-)%s*$", "%1")
end

function Utils.runFile(filepath)
	return Utils.exec(("lua main.lua %s"):format(filepath))
end

function Utils.runProgram(program)
	local file = Utils.randomPath()
	local fp = io.open(file, "w")

	if fp == nil then
		print("Error: Unable to create file with program.")
		os.exit(1)
	end

	fp:write(program)

	fp:close()

	return Utils.runFile(file)
end

function Utils.randomPath()
	local file = "tests/.temp/______.brz"
	local chars = "abcdefghijklmnopqrstuvwxyz1234567890_"

	local path = file:gsub("_", function()
		local idx = math.floor(math.random(#chars))
		local sub = chars:sub(idx, idx)

		return sub
	end)

	return path
end

function Utils.clearDir(dir)
	if package.config:sub(1,1) == "\\" then  -- Windows
		os.execute(("del /F/Q %s"):format(dir:gsub("/", "\\")))
	else
		os.execute(("rm -f %s/*"):format(dir))
	end
end

function Utils.mkdir(dir)
	local fp = nil

	if package.config:sub(1,1) == "\\" then  -- Windows
		dir = dir:gsub("/", "\\")
		fp = io.popen(("mkdir %s 2>nul"):format(dir))
	else
		fp = io.popen(("mkdir -p %s 2>/dev/null"):format(dir))
	end


	if fp ~= nil then
		fp:close()
	end
end

return Utils
