local math_methods = {}

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
			("Expected %d arguments for 'math.%s', but only found %d arguments on the stack."):
			format(count, ErrorInfo.method_token.value, #ErrorInfo.stack),
			ErrorInfo.method_token,
			ErrorInfo.lines
		)
	end
end

local function validateType(token, type_)
	type_ = type_ or TokenType.NUMBER

	if token.type ~= type_ then
		Error.show(
			("Expected number type for 'math.%s' but encountered '%s'."):
			format(ErrorInfo.method_token.value, token.type:lower()),
			token,
			ErrorInfo.lines
		)
	end
end

local function applyMethod(token, method)
	utils.push(ErrorInfo.stack, Token.new(
		TokenType.NUMBER,
		method(token.value),
		token.loc
	))
end

function math_methods.toint(stack, method_token, lines)
	ErrorInfo.stack = stack
	ErrorInfo.lines = lines
	ErrorInfo.method_token = method_token

	validateCount(1)

	local token = utils.pop(ErrorInfo.stack)

	-- Just to verify if is a valid string
	local value = tonumber(token.value)
	if value == nil then
		Error.show(
			("Expected a string with a valid number value, not '%s'."):format(token.value),
			token,
			lines
		)
	end

	applyMethod(token, function(value)
		local num, _ = math.modf(tonumber(value))
		return num
	end)
end

return math_methods
