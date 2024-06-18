local table_methods = {}

local Error = require("src.error")
local utils = require("src.utils")
local pprint = require("lib.pprint")

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
			("Expected %d arguments for 'table.%s', but only found %d arguments on the stack."):
			format(count, ErrorInfo.method_token.value, #ErrorInfo.stack),
			ErrorInfo.method_token,
			ErrorInfo.lines
		)
	end
end

local function validateType(token, type_)
	type_ = type_ or TokenType.TABLE

	if token.type ~= type_ then
		Error.show(
			("Expected a table for 'table.%s' but encountered '%s'."):
			format(ErrorInfo.method_token.value, token.type:lower()),
			token,
			ErrorInfo.lines
		)
	end
end

function table_methods.length(stack, method_token, lines)
	ErrorInfo.stack = stack
	ErrorInfo.lines = lines
	ErrorInfo.method_token = method_token

	validateCount(1)
	local token = utils.pop(ErrorInfo.stack)
	validateType(token)

	utils.push(stack, Token.new(
		TokenType.NUMBER,
		#token.value,
		token.loc
	))
end

function table_methods.pop(stack, method_token, lines)
	ErrorInfo.stack = stack
	ErrorInfo.lines = lines
	ErrorInfo.method_token = method_token

	validateCount(1)
	local token = utils.pop(ErrorInfo.stack)
	validateType(token)

	local value = table.remove(token.value, #token.value)

	utils.push(stack, Token.new(
		value.type,
		value.value,
		token.loc
	))
end

return table_methods
