local pprint = require("lib.pprint")

local Lexer = require("src.lexer")
local Error = require("src.error")
local Tokens = require("src.token")
local TokenType = Tokens.TokenType

local Parser = {
	program = {},
	stack = {},
	lines = {},
	defines = {}
}

Parser.__index = Parser
Parser.debug = true

local function push(stack, value)
	stack[#stack + 1] = value
end

local function pop(stack)
	return table.remove(stack, #stack)
end

local function readFile(filepath)
	-- First: Verify in user local folder
	local fp = io.open(filepath, "r")

	if fp == nil then
		-- Then: Verify in beremiz include folder
		fp = io.open("includes/"..filepath, "r")

		if fp == nil then
			return nil
		end
	end

	local content = fp:read("*a")
	fp:close()

	return content
end

function Parser:new(tokens, raw)
	local obj = setmetatable({}, Parser)

	obj.lines = Error.splitLines(raw)
	obj.stack = {}
	obj.defines = {}

	tokens = obj:include(tokens)
	tokens = obj:crossref(tokens)

	obj.program = tokens

	return obj
end

function Parser:include(tokens)
	local ip = 1

	while true do
		local token = tokens[ip]

		if token.type == TokenType.EOF then
			break
		end

		if token.type == TokenType.INCLUDE then
			local token_path = tokens[ip+1]

			-- Remove 'include'
			table.remove(tokens, ip)

			if token_path.type ~= TokenType.STRING then
				Error.show(
					("Expected 'string' but encountered a '%s'."):format(token_path.type:lower()),
					token,
					self.lines
				)
			end

			local file_content = readFile(token_path.value)

			if file_content == nil then
				Error.show(
					("Could not find the file '%s'."):format(token_path.value),
					token_path,
					self.lines
				)
			end

			-- Remove 'path'
			table.remove(tokens, ip)

			-- Lex to retrieve tokens
			local lexer = Lexer:new(token_path.value, file_content)
			lexer.debug = false
			local include_tokens = lexer:scan()

			-- Parse tokens to check errors
			local parser = Parser:new(include_tokens, file_content)
			parser:parse()

			for _, tok in ipairs(include_tokens) do
				if tok.type ~= TokenType.EOF then
					table.insert(tokens, tok)
				end
			end

			ip = ip - 1
		end

		ip = ip + 1
	end

	return tokens
end

function Parser:crossref(tokens)
	local ip_stack = {}

	for ip, token in ipairs(tokens) do
		if token.type == TokenType.DEFINE then
			local tokenName = tokens[ip+1]

			if tokenName.type ~= TokenType.IDENTIFIER then
				Error.show(
					("Syntax Error: Expected 'identifier' but encountered '%s'."):format(tokenName.type:lower()),
					tokenName,
					self.lines
				)
			end

			self.defines[tokenName.value] = ip+2 -- after define name

			push(ip_stack, ip)

		elseif token.type == TokenType.IF then
			push(ip_stack, ip)

		elseif token.type == TokenType.ELSE then
			local ip_if = pop(ip_stack)

			if tokens[ip_if].type ~= TokenType.IF then
				Error.show(
					"Syntax Error: `ELSE` token encountered without preceding `IF` statement.",
					tokens[ip],
					self.lines
				)
			end

			tokens[ip_if].jump_ip = ip+1

			push(ip_stack, ip)

		elseif token.type == TokenType.WHILE then
			push(ip_stack, ip)

		elseif token.type == TokenType.DO then
			push(ip_stack, ip)

		elseif token.type == TokenType.END then
			local ip_block = pop(ip_stack)

			if tokens[ip_block].type == TokenType.DO then
				local ip_while = pop(ip_stack)

				if tokens[ip_while].type ~= TokenType.WHILE then
					Error.show(
						"Syntax Error: The `DO` token must appear immediately after a `WHILE` statement.",
						tokens[ip],
						self.lines
					)
				end

				tokens[ip].jump_ip = ip_while
			end

			tokens[ip_block].jump_ip = ip+1
		end
	end

	return tokens
end

function Parser:parse()
	local ip = 1
	local returns = {}

	while true do
		local token = self.program[ip]

		if token.type == TokenType.EOF then
			break
		end

		if token.type == TokenType.NUMBER then
			push(self.stack, token.value)
			ip = ip + 1

		elseif token.type == TokenType.NIL then
			push(self.stack, token.value)
			ip = ip + 1

		elseif token.type == TokenType.STRING then
			-- Unlike Lua, string interpolations are 0-based
			local pattern = "[^\\]?%$(%d+)"   -- Match $1, $42, $890, ... with escape \$

			if not token.value:find(pattern) then
				push(self.stack, token.value)

			else
				local delims = {}

				for delim in string.gmatch(token.value, pattern) do
					local value = tonumber(delim)

					delims[#delims+1] = value
				end

				table.sort(delims, function(a, b) return a < b end)

				local max = delims[#delims]
				if max+1 > #self.stack then
					Error.show(
						("Attempted to interpolate element at index %d, but the stack only contains %d elements."):format(max, #delims),
						token,
						self.lines
					)
				end

				local values = {}
				for _ = 1,max+1 do
					values[#values+1] = pop(self.stack)
				end

				local newString = token.value:gsub(pattern,
				function(str)
					return " " .. tostring(values[tonumber(str)+1])
				end)

				push(self.stack, newString)
			end

			ip = ip + 1

		elseif
			token.type == TokenType.PLUS    or
			token.type == TokenType.MINUS   or
			token.type == TokenType.STAR    or
			token.type == TokenType.SLASH   or
			token.type == TokenType.MOD     or
			token.type == TokenType.GREATER or
			token.type == TokenType.EQUAL   or
			token.type == TokenType.NEQUAL
		then
			local b = pop(self.stack)
			local a = pop(self.stack)

			local type_a = type(a)
			local type_b = type(b)

			ip = ip + 1

			if token.type == TokenType.PLUS then
				if type_a == "number" and type_b == "number" then
					push(self.stack, a + b)
				elseif type_a == "string" and type_b == "string" then
					push(self.stack, a .. b)
				else
					Error.show(
				    	("Attempt to add a '%s' with a '%s'."):format(type_a, type_b),
				    	token,
				    	self.lines
				    )
				end

			elseif token.type == TokenType.MINUS then
				if type_a == "number" and type_b == "number" then
					push(self.stack, a - b)
				else
					Error.show(
				    	("Attempt to sub a '%s' with a '%s'."):format(type_a, type_b),
				    	token,
				    	self.lines
				    )
				end

			elseif token.type == TokenType.STAR then
				if type_a == "number" and type_b == "number" then
					push(self.stack, a * b)
				else
					Error.show(
				    	("Attempt to mul a '%s' with a '%s'."):format(type_a, type_b),
				    	token,
				    	self.lines
				    )
				end

			elseif token.type == TokenType.SLASH then
				if type_a == "number" and type_b == "number" then
					push(self.stack, a / b)
				else
					Error.show(
				    	("Attempt to div a '%s' with a '%s'."):format(type_a, type_b),
				    	token,
				    	self.lines
				    )
				end

			elseif token.type == TokenType.GREATER then
				if type_a == "number" and type_b == "number" then
					push(self.stack, a > b)
				else
					Error.show(
				    	("Attempt to compare '%s' with '%s'."):format(type_a, type_b),
				    	token,
				    	self.lines
				    )
				end

			elseif token.type == TokenType.MOD then
				if type_a == "number" and type_b == "number" then
					push(self.stack, a % b)
				else
					Error.show(
				    	("Attempt to mod a '%s' with a '%s'."):format(type_a, type_b),
				    	token,
				    	self.lines
				    )
				end

			elseif token.type == TokenType.EQUAL then
				push(self.stack, a == b)

			elseif token.type == TokenType.NEQUAL then
				push(self.stack, a ~= b)

			end

		elseif token.type == TokenType.DUP then
			local value = pop(self.stack)

			push(self.stack, value)
			push(self.stack, value)
			ip = ip + 1

		elseif token.type == TokenType.IF then
			local cond = pop(self.stack)

			if not cond then
				ip = token.jump_ip
			else
				ip = ip + 1
			end

		elseif token.type == TokenType.ELSE then
			ip = token.jump_ip

		elseif token.type == TokenType.DO then
			local cond = pop(self.stack)

			if not cond then
				ip = token.jump_ip
			else
				ip = ip + 1
			end

		elseif token.type == TokenType.WHILE then
			ip = ip + 1

		elseif token.type == TokenType.END then
			local returnTo = pop(returns)

			if returnTo ~= nil then
				ip = returnTo

			elseif token.jump_ip ~= nil then
				ip = token.jump_ip

			else
				-- TODO: Maybe this is a error
				ip = ip + 1
			end

		elseif token.type == TokenType.OVER then
			local a = pop(self.stack)
			local b = pop(self.stack)

			push(self.stack, b)
			push(self.stack, a)
			push(self.stack, b)
			ip = ip + 1

		elseif token.type == TokenType.SWAP then
			local a = pop(self.stack)
			local b = pop(self.stack)

			push(self.stack, a)
			push(self.stack, b)
			ip = ip + 1

		elseif token.type == TokenType.DROP then
			pop(self.stack)
			ip = ip + 1

		elseif token.type == TokenType.DUMPSTACK then
			local stack = table.concat(self.stack, ", ")
			io.write("[STACK]: ["..stack.."]\n")
			ip = ip + 1

		elseif token.type == TokenType.SHOW then
			local value = pop(self.stack)
			io.write(tostring(value), '\n')

			ip = ip + 1

		elseif token.type == TokenType.DEFINE then
			ip = token.jump_ip

		elseif token.type == TokenType.IDENTIFIER then
			local ipToJump = self.defines[token.value]

			if ipToJump == nil then
				Error.show(
					("Undefined identifier '%s'."):format(token.value),
					token,
					self.lines
				)
			end

			push(returns, ip+1)
			ip = ipToJump

		else
			Error.show(("Not implemented: '%s'."):format(token.type), token, self.lines)

		end
	end
end

return Parser
