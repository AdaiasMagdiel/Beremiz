local utils = {}

function utils.push(stack, value)
	table.insert(stack, value)
end

function utils.pop(stack)
	return table.remove(stack, #stack)
end

function utils.readFile(filepath)
	-- First: Verify in user local folder
	local fp = io.open(filepath, "r")

	if fp == nil then
		return nil
	end

	local content = fp:read("*a")
	fp:close()

	return content
end

return utils
