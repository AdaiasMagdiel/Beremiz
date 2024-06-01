local Tokens = require("src.token")
local Token = Tokens.Token
local TokenType = Tokens.TokenType

local Lexer = {
	current = 1,
	content = "",
	tokens  = {}
}
Lexer.__index = Lexer
Lexer.debug = true

function Lexer:new(content)
	local obj = setmetatable({}, Lexer)

	obj.current = 1
	obj.content = content or ""
	obj.tokens = {}

	return obj
end

function Lexer:isAtEnd()
	return self.current > #self.content
end

function Lexer:consume()
	if self:isAtEnd() then return nil end

	local char = self.content:sub(self.current, self.current)
	self.current = self.current + 1

	return char
end

function Lexer:peek(start, stop)
	if self:isAtEnd() then return nil end

	start = start or 0
	stop = stop or 0
	local char = self.content:sub(self.current+start, self.current+stop)

	return char
end

function Lexer:next()
	return self:peek(1, 1)
end

function Lexer:previous()
	return self:peek(-1, -1)
end

function Lexer.isNumber(char)
	return (char >= '0' and char <= '9')
end

function Lexer.isAlpha(char)
	return	(char >= 'a' and char <= 'z') or
			(char >= 'A' and char <= 'Z') or
			(char == '_')
end

function Lexer.isAlphaNum(char)
	return Lexer.isNumber(char) or Lexer.isAlpha(char)
end

function Lexer:extractNumber()
	local start = self.current

	while true do
		local c = self:peek()

		if not Lexer.isNumber(c) then
			if c ~= '.' and c ~= '_' then
				break
			end
		end

		self:consume()
	end

	local value = self.content:sub(start, self.current):gsub('_', '')

	return tonumber(value)
end

function Lexer:extractString()
	self:consume()  -- chop left "
	local start = self.current

	while true do
		local c = self:peek()

		if self:isAtEnd() then
			-- Error: Unclosed string.
			break
		end

		if c == '"' then
			if self:previous() ~= '\\' then
				break
			end
		end

		self:consume()
	end

	local value = self.content:sub(start, self.current-1)

	value = value:gsub("\\n", '\n')
	value = value:gsub("\\t", '\t')
	value = value:gsub("\\r", '\r')

	return value
end

function Lexer:extractIdentifier()
	local start = self.current

	while true do
		local c = self:peek()

		if not self.isAlphaNum(c) then
			break
		end

		self:consume()
	end

	local value = self.content:sub(start, self.current-1)

	return value
end

function Lexer:scan()
	while not self:isAtEnd() do
		local c = self:peek()

		-- Numbers
		if	self.isNumber(c) or
			(c == '.' and self.isNumber(self:next()))  -- numbers like: .2, .42
		then
			local value = self:extractNumber()
			self.tokens[#self.tokens+1] = Token.new(TokenType.NUMBER, value)

			if self.debug then
				io.write('Lexer->scan->isNumber(c): ', value, '\n')
			end

		-- Strings
		elseif c == '"' then
			local value = self:extractString()
			self.tokens[#self.tokens+1] = Token.new(TokenType.STRING, value)

			if self.debug then
				io.write('Lexer->scan->isString(c): ', value, '\n')
			end

		-- Identifiers
		elseif self.isAlpha(c) then
			local value = self:extractIdentifier()

			local identifiers = {
				["show"]  = TokenType.SHOW,
				["if"]    = TokenType.IF,
				["else"]  = TokenType.ELSE,
				["dup"]   = TokenType.DUP,
				["while"] = TokenType.WHILE,
				["do"]    = TokenType.DO,
				["end"]   = TokenType.END,
				["over"]  = TokenType.OVER,
				["swap"]  = TokenType.SWAP,
				["drop"]  = TokenType.DROP,
			}

			local type = nil
			if identifiers[value] ~= nil then
				type = identifiers[value]
			else
				type = TokenType.IDENTIFIER
			end

			self.tokens[#self.tokens+1] = Token.new(type, value)

			if self.debug then
				io.write('Lexer->scan->isIdentifier(c): ', value, '\n')
			end

		-- Comments
		elseif c == "#" then
			if self:next() == '[' then
				while true do
					self:consume()

					if self:peek() == ']' and self:next() == '#' then
						self:consume()
						break
					end
				end

			else
				while self:consume() ~= '\n' do end
			end

		elseif
			c == "+" or
			c == "-" or
			c == "*" or
			c == "/" or
			c == ">" or
			c == "=" or
			c == "%"
		then
			local type = ({
							["+"]=TokenType.PLUS,
							["-"]=TokenType.MINUS,
							["*"]=TokenType.STAR,
							["/"]=TokenType.SLASH,
							[">"]=TokenType.GREATER,
							["="]=TokenType.EQUAL,
							["%"]=TokenType.MOD,
						})[c]

			self.tokens[#self.tokens+1] = Token.new(type, c)

			if self.debug then
				io.write('Lexer->scan->isOperator(c): ', c, '\n')
			end
		end

		self:consume()
	end

	self.tokens[#self.tokens+1] = Token.new(TokenType.EOF, '')

	return self.tokens
end

return Lexer