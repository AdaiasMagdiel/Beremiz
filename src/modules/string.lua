local string_methods = {}

local Error = require("src.error")
local utils = require("src.utils")

local Tokens = require("src.token")
local Token = Tokens.Token
local TokenType = Tokens.TokenType

local function validateCount(stack, count, method_token, lines)
	if #stack < count then
		Error.error(
			("Expected %d arguments for 'string.%s', but only found %d arguments on the stack."):
			format(count, method_token.value, #stack),
			method_token,
			lines
		)
	end
end

local function validateType(stack, token, method_token, lines)
	if token.type ~= TokenType.STRING then
		Error.error(
			("Expected string type for 'string.%s' but encountered '%s'."):
			format(method_token.value, token.type:lower()),
			method_token,
			lines
		)
	end
end

local function applyMethod(stack, token, method)
	utils.push(stack, Token.new(
		TokenType.STRING,
		method(token.value),
		token.loc
	))
end

function string_methods.upper(stack, method_token, lines)
	validateCount(stack, 1, method_token, lines)

	local token = utils.pop(stack)

	validateType(stack, token, method_token, lines)

	applyMethod(stack, token, string.upper)
end

function string_methods.lower(stack, method_token, lines)
	validateCount(stack, 1, method_token, lines)

	local token = utils.pop(stack)

	validateType(stack, token, method_token, lines)

	applyMethod(stack, token, string.lower)
end

return string_methods
