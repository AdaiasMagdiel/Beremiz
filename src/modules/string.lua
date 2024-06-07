local string_methods = {}

local Error = require("src.error")
local utils = require("src.utils")
local pprint = require("pprint")

local Tokens = require("src.token")
local Token = Tokens.Token
local TokenType = Tokens.TokenType

local ErrorInfo = {
	stack = {},
	lines = {},
	method_token = {}
}

local function validateCount(count)
	if #ErrorInfo.stack < count then
		Error.show(
			("Expected %d arguments for 'string.%s', but only found %d arguments on the stack."):
			format(count, ErrorInfo.method_token.value, #ErrorInfo.stack),
			ErrorInfo.method_token,
			ErrorInfo.lines
		)
	end
end

local function validateType(token, type_)
	type_ = type_ or TokenType.STRING

	if token.type ~= type_ then
		Error.show(
			("Expected string type for 'string.%s' but encountered '%s'."):
			format(ErrorInfo.method_token.value, token.type:lower()),
			token,
			ErrorInfo.lines
		)
	end
end

local function applyMethod(token, method)
	utils.push(ErrorInfo.stack, Token.new(
		TokenType.STRING,
		method(token.value),
		token.loc
	))
end

function string_methods.upper(stack, method_token, lines)
	ErrorInfo.stack = stack
	ErrorInfo.lines = lines
	ErrorInfo.method_token = method_token

	validateCount(1)
	local token = utils.pop(ErrorInfo.stack)
	validateType(token)

	applyMethod(token, string.upper)
end

function string_methods.lower(stack, method_token, lines)
	ErrorInfo.stack = stack
	ErrorInfo.lines = lines
	ErrorInfo.method_token = method_token

	validateCount(1)
	local token = utils.pop(ErrorInfo.stack)
	validateType(token)

	applyMethod(token, string.lower)
end

function string_methods.split(stack, method_token, lines)
	ErrorInfo.stack = stack
	ErrorInfo.lines = lines
	ErrorInfo.method_token = method_token

	validateCount(2)

	local separator = utils.pop(stack)
	validateType(separator)

	local token = utils.pop(stack)
	validateType(token)

	local parts = {}

	for part in token.value:gmatch(("([^%s]+)"):format(separator.value)) do
		table.insert(parts, 1, part)
	end

	for _, part in ipairs(parts) do
		utils.push(stack, Token.new(
			TokenType.STRING,
			part,
			token.loc
		))
	end
end

return string_methods
