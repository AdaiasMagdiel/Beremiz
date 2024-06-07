local Leste = require("leste.leste")
local Assertions = require("leste.assertions")
local Utils = require("tests.utils")

-- DEFINE

Leste.it("should raise a error when not found a method", function()
	local output = Utils.runProgram('"abc" string.not_exists show')

	Assertions.assert(output:find("Undefined method 'not_exists' for 'string'"))
end)

Leste.it("should to uppercase a string", function()
	local output = Utils.runProgram('"abc" string.upper show')

	Assertions.equal(output, "ABC")
end)

Leste.it("should to lowercase a string", function()
	local output = Utils.runProgram('"ABC" string.lower show')

	Assertions.equal(output, "abc")
end)
