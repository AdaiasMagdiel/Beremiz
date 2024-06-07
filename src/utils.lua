local utils = {}

function utils.push(stack, value)
	table.insert(stack, value)
end

function utils.pop(stack)
	return table.remove(stack, #stack)
end

return utils
