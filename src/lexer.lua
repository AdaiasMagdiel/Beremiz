local Error = require("src.error")
local pprint = require("lib.pprint")

local Tokens = require("src.token")
local Token = Tokens.Token
local TokenType = Tokens.TokenType
local Loc = Tokens.Loc

local Lexer = {
	file = "",
	line = 1,
	col = 1,
	current = 1,
	content = "",
	tokens  = {}
}
Lexer.__index = Lexer
Lexer.debug = true

function Lexer:new(filepath, content)
	local obj = setmetatable({}, Lexer)

	obj.file = filepath
	obj.line = 1
	obj.col = 1

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
	self.col = self.col + 1

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
	local minus = 0
	local dot = 0

	while true do
		local c = self:peek()

		if not Lexer.isNumber(c) then
			if c == '.' then dot = dot + 1 end
			if c == '-' then minus = minus + 1 end

			if dot > 1 then
				Error.show(
					("Malformed number near '%s'."):format(self.content:sub(start, self.current+1)),
					{loc=Loc(self.file, self.line, start)},
					Error.splitLines(self.content)
				)
			end

			if minus > 1 then
				Error.show(
					("Malformed number near '%s'."):format(self.content:sub(start, self.current+1)),
					{loc=Loc(self.file, self.line, start)},
					Error.splitLines(self.content)
				)
			end

			if c ~= '.' and c ~= '_' and c ~= '-' then
				break
			end
		end

		self:consume()
	end

	local value = self.content:sub(start, self.current):gsub('_', '')

	return tonumber(value)
end

function Lexer:extractString()
	local startLine = self.line
	local startCol = self.col

	self:consume()  -- remove the first quote
	local start = self.current

	while true do
		local c = self:peek()

		if self:isAtEnd() then
			local lines = Error.splitLines(self.content)

			Error.show(
				"Error: Unclosed string.",
				{loc={file=self.file, line=startLine, col=startCol-1}},
				lines
			)

			break
		end

		if c == "\n" then
			self.line = self.line + 1
			self.col = 1
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

		if c == nil then
			break
		end

		if c == "\n" then
			self.line = self.line + 1
			self.col = 1
		end

		if not self.isAlphaNum(c) then
			break
		end

		self:consume()
	end

	local value = self.content:sub(start, self.current-1)

	return value
end

function Lexer:removeComments()
	-- os.exit(1)
	self:consume()  -- Remove #

	-- Multi-line
	if self:peek() == "[" then
		self:consume()  -- Remove [

		while true do
			local c = self:peek()

			if c == nil or self:isAtEnd() then
				break
			end

			if c == "\n" then
				self.line = self.line + 1
				self.col = 1
			end

			if self:peek() == "]" and self:next() == "#" then
				self:consume()
				self:consume()

				if self:peek() == "\n" then
					self.line = self.line + 1
					self.col = 1
				end

				break
			end

			self:consume()
		end
	else
		while self:peek() ~= "\n" do
			if self:peek() == nil or self:isAtEnd() then
				break
			end

			self:consume()
		end

		self.line = self.line + 1
		self.col = 1
	end
end

function Lexer:scan()
	while not self:isAtEnd() do
		local c = self:peek()

		-- New Line
		if c == "\n" then
			self.line = self.line + 1
			self.col = 1

		-- Not Equal
		elseif c == "!" then
			if self:next() ~= "=" then
				return
			end

			self.tokens[#self.tokens+1] = Token.new(
				TokenType.NEQUAL,
				"!=",
				Loc(self.file, self.line, self.col)
			)

			self:consume() -- Remove !

		-- Numbers
		elseif	self.isNumber(c) or
			(c == '.' and self.isNumber(self:next())) or  -- numbers like: .2, .42
			(c == '-' and self.isNumber(self:next()))     -- numbers like: -1, -15
		then
			local value = self:extractNumber()
			self.tokens[#self.tokens+1] = Token.new(
				TokenType.NUMBER,
				value,
				Loc(self.file, self.line, self.col)
			)

			if self.debug then
				io.write('Lexer->scan->isNumber(c): ', value, '\n')
			end

		-- Strings
		elseif c == '"' then
			local value = self:extractString()
			self.tokens[#self.tokens+1] = Token.new(
				TokenType.STRING,
				value,
				Loc(self.file, self.line, self.col-#value)
			)

			if self.debug then
				io.write('Lexer->scan->isString(c): ', value, '\n')
			end

		-- Identifiers
		elseif self.isAlpha(c) then
			local value = self:extractIdentifier()

			local identifiers = {
				["nil"]   = TokenType.NIL,

				["show"]   = TokenType.SHOW,
				["if"]     = TokenType.IF,
				["else"]   = TokenType.ELSE,
				["while"]  = TokenType.WHILE,
				["do"]     = TokenType.DO,
				["end"]    = TokenType.END,
				["define"] = TokenType.DEFINE,

				["dup"]       = TokenType.DUP,
				["over"]      = TokenType.OVER,
				["drop"]      = TokenType.DROP,
				["swap"]      = TokenType.SWAP,
				["dumpstack"] = TokenType.DUMPSTACK,
			}

			local type = nil
			if identifiers[value] ~= nil then
				type = identifiers[value]
			else
				type = TokenType.IDENTIFIER
			end

			self.tokens[#self.tokens+1] = Token.new(
				type,
				value,
				Loc(self.file, self.line, self.col-#value)
			)

			if self.debug then
				io.write('Lexer->scan->isIdentifier(c): ', value, '\n')
			end

		-- Comments
		elseif c == "#" then
			self:removeComments()

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

			self.tokens[#self.tokens+1] = Token.new(
				type,
				c,
				Loc(self.file, self.line, self.col-1)
			)

			if self.debug then
				io.write('Lexer->scan->isOperator(c): ', c, '\n')
			end
		end

		self:consume()
	end

	self.tokens[#self.tokens+1] = Token.new(
		TokenType.EOF,
		'',
		Loc(self.file, self.line, self.col)
	)

	return self.tokens
end

return Lexer
