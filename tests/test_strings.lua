local Leste = require("leste.leste")
local Assertions = require("leste.assertions")
local Utils = require("tests.utils")

Leste.it("should handle strings correctly", function()
	local output = Utils.runProgram('"Hello" show')

	Assertions.equal(output, "Hello")
end)

Leste.it("should escape characters in strings correctly", function()
	local output = Utils.runProgram('"A \t B \n C" show')

	Assertions.equal(output, "A \t B \n C")
end)

Leste.it("should show error for unclosed strings", function()
	local output = Utils.runProgram('"ABC show')

	Assertions.assert(output:find("Unclosed string."))
end)

Leste.it("should handle string interpolation", function()
	local output = Utils.runProgram('1 2 3 "values: $2, $1, $0" show')

	Assertions.equal(output, "values: 1, 2, 3")
end)

Leste.it("should escape $n correctly", function()
	local output = Utils.runProgram('1 2 "values: $1, $0 | Escape: \\$42" show')

	Assertions.equal(output, "values: 1, 2 | Escape: $42")
end)

Leste.it("should show error for string interpolation overflow", function()
	local output = Utils.runProgram('1 2 "values: $1, $0, $2" show')

	Assertions.assert(output:find("Attempted to interpolate element at index"))
	Assertions.assert(output:find("but the stack only contains 2 elements"))
end)
