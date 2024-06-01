local pprint = require("lib.pprint")

local Tokens = require("src.token")
local Token = Tokens.Token
local TokenType = Tokens.TokenType

local Parser = {
	program = {},
	stack = {}
}

Parser.__index = Parser
Parser.debug = true

local function push(stack, value)
	stack[#stack + 1] = value
end

local function pop(stack)
	return table.remove(stack, #stack)
end

function Parser:new(tokens)
	local obj = setmetatable({}, Parser)

	obj.program = self.crossref(tokens)
	obj.stack = {}

	return obj
end

function Parser.crossref(tokens)
	local ip_stack = {}

	for ip, token in ipairs(tokens) do
		if token.type == TokenType.IF then
			push(ip_stack, ip)

		elseif token.type == TokenType.ELSE then
			local ip_if = pop(ip_stack)
			tokens[ip_if].ip_end = ip

			push(ip_stack, ip)

		elseif token.type == TokenType.WHILE then
			push(ip_stack, ip)

		elseif token.type == TokenType.DO then
			push(ip_stack, ip)

		elseif token.type == TokenType.END then
			local ip_block = pop(ip_stack)

			if tokens[ip_block].type == TokenType.DO then
				local ip_while = pop(ip_stack)

				tokens[ip].ip_end = ip_while
			end

			tokens[ip_block].ip_end = ip

		end
	end

	return tokens
end

function Parser:parse()
	local ip = 1
	while true do
		local token = self.program[ip]
		if token.type == TokenType.EOF then
			break
		end

		if
			token.type == TokenType.STRING or
			token.type == TokenType.NUMBER
		then
			push(self.stack, token.value)

		elseif
			token.type == TokenType.PLUS    or
			token.type == TokenType.MINUS   or
			token.type == TokenType.STAR    or
			token.type == TokenType.SLASH   or
			token.type == TokenType.GREATER or
			token.type == TokenType.EQUAL   or
			token.type == TokenType.MOD
		then
			local b = pop(self.stack)
			local a = pop(self.stack)

			if token.type == TokenType.PLUS then
				push(self.stack, a + b)
			elseif token.type == TokenType.MINUS then
				push(self.stack, a - b)
			elseif token.type == TokenType.STAR then
				push(self.stack, a * b)
			elseif token.type == TokenType.SLASH then
				push(self.stack, a / b)
			elseif token.type == TokenType.GREATER then
				push(self.stack, a > b and 1 or 0)
			elseif token.type == TokenType.EQUAL then
				push(self.stack, a == b and 1 or 0)
			elseif token.type == TokenType.MODULE then
				push(self.stack, a % b)
			end

		elseif token.type == TokenType.DUP then
			local value = pop(self.stack)

			push(self.stack, value)
			push(self.stack, value)

		elseif token.type == TokenType.IF then
			local cond = pop(self.stack)

			if cond == 0 then
				ip = token.ip_end
			end

		elseif token.type == TokenType.ELSE then
			ip = token.ip_end

		elseif token.type == TokenType.DO then
			local cond = pop(self.stack)

			if cond == 0 then
				ip = token.ip_end
			end

		elseif token.type == TokenType.END then
			if token.ip_end ~= nil then
				ip = token.ip_end
			end

		elseif token.type == TokenType.OVER then
			local a = pop(self.stack)
			local b = pop(self.stack)

			push(self.stack, b)
			push(self.stack, a)
			push(self.stack, b)

		elseif token.type == TokenType.SWAP then
			local a = pop(self.stack)
			local b = pop(self.stack)

			push(self.stack, a)
			push(self.stack, b)

		elseif token.type == TokenType.DROP then
			pop(self.stack)

		elseif token.type == TokenType.SHOW then
			local value = pop(self.stack)
			io.write(value, '\n')
		end

		ip = ip + 1
	end
end

return Parser
