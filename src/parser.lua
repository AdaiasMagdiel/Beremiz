local pprint = require("lib.pprint")

local utils = require("src.utils")
local Lexer = require("src.lexer")
local Error = require("src.error")

local Tokens = require("src.token")
local Token = Tokens.Token
local TokenType = Tokens.TokenType

local Parser = {
	tokens = {},
	stack = {},
	lines = {},
	defines = {},
	modules = {},
	program = {}
}

Parser.__index = Parser
Parser.debug = false

function Parser:new(tokens, raw)
	local obj = setmetatable({}, Parser)

	obj.lines = Error.splitLines(raw)
	obj.stack = {}
	obj.defines = {}
	obj.program = {}

	tokens = obj:resolve_includes(tokens)
	tokens = obj:crossref(tokens)
	obj.tokens = tokens

	obj.modules = {
		["string"] = require("src.modules.string"),
		["math"] = require("src.modules.math")
	}

	return obj
end

function Parser:resolve_includes(tokens)
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

			-- First verify in user local directory. 
			local file_content = utils.readFile(token_path.value)

			-- If it's not found, verify in language include directory.
			if file_content == nil then
				local root_path = debug.getinfo(2, "S").source:sub(2):match("(.*[\\/])") .. ".."
				local BRZ_INCLUDE_DIR = root_path .. "/includes/"

				file_content = utils.readFile(BRZ_INCLUDE_DIR .. token_path.value)
			end

			-- Raise a error if the file not exists.
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
	local break_stack = {}
	local continue_stack = {}
	local inside_loop = false

	for ip, token in ipairs(tokens) do
		if token.type == TokenType.DEFINE then
			local tokenName = tokens[ip+1]

			if tokenName == nil then
				Error.show(
					"Syntax Error: Expected 'identifier'.",
					token,
					self.lines
				)
				return
			end

			if tokenName.type ~= TokenType.IDENTIFIER then
				Error.show(
					("Syntax Error: Expected 'identifier' but encountered '%s'."):
					format(tokenName.type:lower()),
					tokenName,
					self.lines
				)
			end

			if self.modules[tokenName.value] ~= nil then
				Error.show(
					"You are trying to redefine the reserved keyword '%s'. " ..
					("Reserved keywords are used by the language and cannot be changed."):
					format(tokenName.value),
					tokenName,
					self.lines
				)
			end

			self.defines[tokenName.value] = ip+2 -- after define name

			utils.push(ip_stack, ip)

		elseif token.type == TokenType.IF then
			utils.push(ip_stack, ip)

		elseif token.type == TokenType.ELSE then
			local ip_block_do = utils.pop(ip_stack)
			local ip_block_if = utils.pop(ip_stack)

			if ip_block_do == nil or
			   tokens[ip_block_do].type ~= TokenType.DO
			then
			   	Error.show(
					"Syntax Error: expected a `IF-DO` statement to be used with `ELSE`.",
					tokens[ip],
					self.lines
				)
			end

			if ip_block_if == nil or
			   tokens[ip_block_if].type ~= TokenType.IF
			then
			   	Error.show(
					"Syntax Error: `ELSE` only can be used with a `IF-DO` statement.",
					tokens[ip],
					self.lines
				)
			end

			tokens[ip_block_do].jump_ip = ip+1

			utils.push(ip_stack, ip)

		elseif token.type == TokenType.WHILE then
			inside_loop = true

			utils.push(continue_stack, ip)
			utils.push(ip_stack, ip)

		elseif token.type == TokenType.BREAK then
			if not inside_loop then
				Error.show(
					"`BREAK` only can be used inside `WHILE` loops.",
					tokens[ip],
					self.lines
				)
			end

			utils.push(break_stack, ip)

		elseif token.type == TokenType.CONTINUE then
			if not inside_loop then
				Error.show(
					"`CONTINUE` only can be used inside `WHILE` loops.",
					tokens[ip],
					self.lines
				)
			end

			-- Add WHILE address to CONTINUE
			local continue_token = continue_stack[#continue_stack]
			if continue_token ~= nil then
				tokens[ip].jump_ip = continue_token
			end

		elseif token.type == TokenType.DO then
			local ip_while_or_if = utils.pop(ip_stack)

			if ip_while_or_if == nil or
			   tokens[ip_while_or_if].type ~= TokenType.IF and
			   tokens[ip_while_or_if].type ~= TokenType.WHILE
			then
				Error.show(
					"Syntax Error: `DO` only can be used with `IF` or `WHILE` statements.",
					tokens[ip],
					self.lines
				)
			end

			utils.push(ip_stack, ip_while_or_if)
			utils.push(ip_stack, ip)

		elseif token.type == TokenType.END then
			local ip_block_to_close = utils.pop(ip_stack)

			if ip_block_to_close == nil or
			   tokens[ip_block_to_close].type ~= TokenType.DEFINE and
			   tokens[ip_block_to_close].type ~= TokenType.DO     and
			   tokens[ip_block_to_close].type ~= TokenType.ELSE
			then
				Error.show(
					"Syntax Error: The `END` token only can close `DEFINE`, `IF-DO` and `WHILE-DO` statements.",
					tokens[ip],
					self.lines
				)
			end

			if tokens[ip_block_to_close].type == TokenType.DO then
				local ip_block = utils.pop(ip_stack)

				-- For WHILE-loops
				if tokens[ip_block].type == TokenType.WHILE then
					-- DO receive the address of token after END
					tokens[ip_block_to_close].jump_ip = ip+1

					-- END receive the WHILE address
					tokens[ip].jump_ip = ip_block

					-- Exit loop
					inside_loop = false

					-- Add address after the END
					local break_token = utils.pop(break_stack)
					if break_token ~= nil then
						tokens[break_token].jump_ip = ip+1
					end

				-- For IF statement
				elseif tokens[ip_block].type == TokenType.IF then
					-- DO receive the address of token after END
					tokens[ip_block_to_close].jump_ip = ip+1

				end
			else
				tokens[ip_block_to_close].jump_ip = ip+1
			end
		end
	end

	return tokens
end

function Parser:parse()
	local ip = 1
	local returns = {}

	while true do
		local token = self.tokens[ip]

		if token.type == TokenType.EOF then
			break
		end

		if token.type == TokenType.NUMBER then
			utils.push(self.stack, token)
			ip = ip + 1

		elseif token.type == TokenType.NIL then
			utils.push(self.stack, token)
			ip = ip + 1

		elseif token.type == TokenType.BOOL then
			utils.push(self.stack, token)
			ip = ip + 1

		elseif token.type == TokenType.STRING then
			-- Unlike Lua, string interpolations are 0-based
			local pattern = "[^\\]%$(%d+)"   -- Match $1, $42, $890, ... with escape \$

			if not token.value:find(pattern) then
				utils.push(self.stack, token)

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
						("Attempted to interpolate element at index %d, but the stack only contains %d elements."):format(max, #delims-1),
						token,
						self.lines
					)
				end

				local values = {}
				for _ = 1,max+1 do
					values[#values+1] = utils.pop(self.stack).value
				end

				local newString = token.value:gsub(pattern,
				function(str)
					return (" " .. tostring(values[tonumber(str)+1]))
				end)

				utils.push(self.stack, Token.new(
					TokenType.STRING,
					newString:gsub("\\%$", "$"),
					token.loc
				))
			end

			ip = ip + 1

		elseif
			token.type == TokenType.PLUS    or
			token.type == TokenType.MINUS   or
			token.type == TokenType.STAR    or
			token.type == TokenType.EXP    or
			token.type == TokenType.SLASH   or
			token.type == TokenType.MOD     or
			token.type == TokenType.GREATER or
			token.type == TokenType.EQUAL   or
			token.type == TokenType.NEQUAL
		then
			if #self.stack < 2 then
				Error.show(
					("Expected %d arguments for this operation, but only found %d arguments on the stack."):
					format(2, #self.stack),
					token,
					self.lines
				)
			end

			local b = utils.pop(self.stack)
			local a = utils.pop(self.stack)

			ip = ip + 1

			-- PLUS +
			if token.type == TokenType.PLUS then
				-- SUM
				if a.type == TokenType.NUMBER and b.type == TokenType.NUMBER then
					utils.push(self.stack, Token.new(
						TokenType.NUMBER,
						a.value + b.value,
						token.loc
					))

				-- CONCAT
				elseif a.type == TokenType.STRING and b.type == TokenType.STRING then
					utils.push(self.stack, Token.new(
						TokenType.STRING,
						a.value .. b.value,
						token.loc
					))

				else
					Error.show(
				    	("Attempt to add a '%s' with a '%s'."):
				    	format(a.type:lower(), b.type:lower()),
				    	token,
				    	self.lines
				    )
				end

			-- MINUS -
			elseif token.type == TokenType.MINUS then
				if a.type == TokenType.NUMBER and b.type == TokenType.NUMBER then
					utils.push(self.stack, Token.new(
						TokenType.NUMBER,
						a.value - b.value,
						token.loc
					))

				else
					Error.show(
				    	("Attempt to sub a '%s' with a '%s'."):format(a.type:lower(), b.type:lower()),
				    	token,
				    	self.lines
				    )
				end

			-- STAR *
			elseif token.type == TokenType.STAR then
				if a.type == TokenType.NUMBER and b.type == TokenType.NUMBER then
					utils.push(self.stack, Token.new(
						TokenType.NUMBER,
						a.value * b.value,
						token.loc
					))

				else
					Error.show(
				    	("Attempt to mul a '%s' with a '%s'."):format(a.type:lower(), b.type:lower()),
				    	token,
				    	self.lines
				    )
				end

			-- EXP **
			elseif token.type == TokenType.EXP then
				if a.type == TokenType.NUMBER and b.type == TokenType.NUMBER then
					utils.push(self.stack, Token.new(
						TokenType.NUMBER,
						a.value ^ b.value,
						token.loc
					))

				else
					Error.show(
				    	("Attempt to exp a '%s' with a '%s'."):format(a.type:lower(), b.type:lower()),
				    	token,
				    	self.lines
				    )
				end

			-- SLASH /
			elseif token.type == TokenType.SLASH then
				if a.type == TokenType.NUMBER and b.type == TokenType.NUMBER then
					utils.push(self.stack, Token.new(
						TokenType.NUMBER,
						a.value / b.value,
						token.loc
					))

				else
					Error.show(
				    	("Attempt to div a '%s' with a '%s'."):format(a.type:lower(), b.type:lower()),
				    	token,
				    	self.lines
				    )
				end

			-- MOD %
			elseif token.type == TokenType.MOD then
				if a.type == TokenType.NUMBER and b.type == TokenType.NUMBER then
					utils.push(self.stack, Token.new(
						TokenType.NUMBER,
						a.value % b.value,
						token.loc
					))

				else
					Error.show(
				    	("Attempt to mod a '%s' with a '%s'."):format(a.type:lower(), b.type:lower()),
				    	token,
				    	self.lines
				    )
				end

			-- GREATER >
			elseif token.type == TokenType.GREATER then
				if a.type == TokenType.NUMBER and b.type == TokenType.NUMBER then
					utils.push(self.stack, Token.new(
						TokenType.BOOL,
						tostring(a.value > b.value),
						token.loc
					))

				else
					Error.show(
				    	("Attempt to compare '%s' with '%s'."):format(a.type:lower(), b.type:lower()),
				    	token,
				    	self.lines
				    )
				end

			-- EQUAL =
			elseif token.type == TokenType.EQUAL then
				utils.push(self.stack, Token.new(
					TokenType.BOOL,
					tostring(a.value == b.value),
					token.loc
				))

			-- NOT EQUAL !=
			elseif token.type == TokenType.NEQUAL then
				utils.push(self.stack, Token.new(
					TokenType.BOOL,
					tostring(a.value ~= b.value),
					token.loc
				))

			end

		elseif token.type == TokenType.DUP then
			local value = utils.pop(self.stack)

			utils.push(self.stack, value)
			utils.push(self.stack, value)
			ip = ip + 1

		elseif token.type == TokenType.IF then
			ip = ip + 1

		elseif token.type == TokenType.ELSE then
			if token.jump_ip == nil then
				Error.show(
					"The `ELSE` token is missing a jump_ip reference. This may be due to a cross-reference error in the language parsing process. It's not your fault.",
					token,
					self.lines
				)
			end

			ip = token.jump_ip

		elseif token.type == TokenType.DO then
			local token_cond = utils.pop(self.stack)

			if token_cond == nil then
				Error.show(
					"Expected a 'boolean' type or 'nil'.",
					token,
					self.lines
				)
				return
			end

			if token_cond.type ~= TokenType.BOOL and
			   token_cond.type ~= TokenType.NIL
			then
				Error.show(
					("Expected to validate a 'boolean' type or 'nil', not '%s'."):format(token_cond.type:lower()),
					token,
					self.lines
				)
			end

			if token_cond.value == "nil" or
			   token_cond.value == "false"
			then
				if token.jump_ip == nil then
					Error.show(
						"The `DO` token is missing a jump_ip reference. This may be due to a cross-reference error in the language parsing process. It's not your fault.",
						token,
						self.lines
					)
				end
				ip = token.jump_ip
			else
				ip = ip + 1
			end

		elseif token.type == TokenType.WHILE then
			ip = ip + 1

		elseif token.type == TokenType.BREAK then
			if token.jump_ip == nil then
				Error.show(
					"The `BREAK` token is missing a jump_ip reference. This may be due to a cross-reference error in the language parsing process. It's not your fault.",
					token,
					self.lines
				)
			end

			ip = token.jump_ip

		elseif token.type == TokenType.CONTINUE then
			if token.jump_ip == nil then
				Error.show(
					"The `CONTINUE` token is missing a jump_ip reference. This may be due to a cross-reference error in the language parsing process. It's not your fault.",
					token,
					self.lines
				)
			end

			ip = token.jump_ip

		elseif token.type == TokenType.END then
			local returnToIp = utils.pop(returns)

			if returnToIp ~= nil then
				ip = returnToIp

			elseif token.jump_ip ~= nil then
				if token.jump_ip == nil then
					Error.show(
						"The `END` token is missing a jump_ip reference. This may be due to a cross-reference error in the language parsing process. It's not your fault.",
						token,
						self.lines
					)
				end
				ip = token.jump_ip

			else
				ip = ip + 1
			end

		elseif token.type == TokenType.OVER then
			local a = utils.pop(self.stack)
			local b = utils.pop(self.stack)

			utils.push(self.stack, b)
			utils.push(self.stack, a)
			utils.push(self.stack, b)
			ip = ip + 1

		elseif token.type == TokenType.SWAP then
			local a = utils.pop(self.stack)
			local b = utils.pop(self.stack)

			utils.push(self.stack, a)
			utils.push(self.stack, b)
			ip = ip + 1

		elseif token.type == TokenType.DROP then
			utils.pop(self.stack)
			ip = ip + 1

		elseif token.type == TokenType.DUMPSTACK then
			io.write("[STACK]:\n")

			for idx, token_ in ipairs(self.stack) do
				io.write("    ", token_.type, ": ", token_.value, " (", type(token_.value), ")")

				io.write("\n")
			end

			ip = ip + 1

		elseif token.type == TokenType.SHOW then
			local token_ = utils.pop(self.stack)
			io.write(tostring(token_.value), '\n')

			ip = ip + 1

		elseif token.type == TokenType.DEFINE then
			if token.jump_ip == nil then
				Error.show(
					"The `DEFINE` token is missing a jump_ip reference. This may be due to a cross-reference error in the language parsing process. It's not your fault.",
					token,
					self.lines
				)
			end
			ip = token.jump_ip

		elseif token.type == TokenType.EXIT then
			local message = utils.pop(self.stack)
			local status = utils.pop(self.stack)

			if message == nil then
				Error.show(
					"Invalid use of the `EXIT` keyword. `EXIT` requires: `message (string), status (int)` or `status (int)` on the stack.",
					token,
					self.lines
				)
				return
			end


			-- If the first token is a number, then is the status
			-- Call the exitProgram function for possible additional cleanups
			if message.type == TokenType.NUMBER then
				self:exitProgram(message)
			end


			-- Here, `message` is not a number, then, verify if is a
			-- string to use as exit message

			if message.type == TokenType.STRING then
				-- Verify the `status` token
				if status == nil then
					Error.show(
						"Invalid use of the `EXIT` keyword. You are trying to call `EXIT` with a message but without a status code.",
						token,
						self.lines
					)
					return
				end


				-- Raise a error if the `status` is not a number
				if status.type ~= TokenType.NUMBER then
					Error.show(
						"Invalid use of the `EXIT` keyword. You are attempting to call `EXIT` with a status code that is not a number.",
						status,
						self.lines
					)
				end

				self:exitProgram(status, message)
			end


			-- If `message_or_status` is not a number and not a string, so,
			-- we have a error

			Error.show(
				"Invalid use of the `EXIT` keyword. `EXIT` requires: `message (string), status (int)` or `status (int)` on the stack.",
				token,
				self.lines
			)

			ip = ip+1

		elseif token.type == TokenType.IDENTIFIER then
			-- Verify in self.defines
			if self.defines[token.value] ~= nil then
				utils.push(returns, ip+1)
				ip = self.defines[token.value]

			-- Verify in self.modules
			elseif self.modules[token.value] ~= nil then
				local nextToken = self.tokens[ip+1]

				if nextToken == nil or nextToken.type ~= TokenType.ACCESS then
					Error.show(
						("Expected method access for '%s'."):format(token.value),
						token,
						self.lines
					)
				end

				ip = ip + 1
			else
				Error.show(
					("Undefined identifier '%s'."):format(token.value),
					token,
					self.lines
				)

			end

		elseif token.type == TokenType.ACCESS then
			-- module.method(value)
			local module = nil
			local method = nil

			-- previousToken = module
			-- nextToken = method
			local previousToken = self.tokens[ip-1]
			local nextToken = self.tokens[ip+1]

			-- module must exists and must be a identifier that exists in self.modules
			if previousToken == nil or previousToken.type ~= TokenType.IDENTIFIER then
				Error.show(
					"Expected module to access method.",
					token,
					self.lines
				)
				return
			end

			-- method must exists and must be a identifier
			if nextToken == nil or nextToken.type ~= TokenType.IDENTIFIER then
				Error.show(
					"Expected method to access.",
					token,
					self.lines
				)
				return
			end

			module = self.modules[previousToken.value]
			method = nextToken.value

			-- Verify if module has method
			if module[method] == nil then
				Error.show(
					("Undefined method '%s' for '%s'."):format(method, previousToken.value),
					token,
					self.lines
				)
			end

			module[method](self.stack, nextToken, self.lines)

			-- Jump method
			ip = ip + 2

		else
			Error.show(("Not implemented: '%s'."):format(token.type), token, self.lines)

		end
	end
end

function Parser:exitProgram(status_token, message_token)
	-- Raise a error if the status code is a float
	if math.type(status_token.value) == "float" then
		Error.show(
			("Invalid status code for `EXIT`. It requires a integer but got '%s'."):format(status_token.value),
			status_token,
			self.lines
		)
	end

	if message_token ~= nil then
		io.stderr:write(string.format("%s\n", message_token.value))
	end

	os.exit(status_token.value)
end

return Parser
