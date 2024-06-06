local Leste = require("leste.leste")
local Assertions = require("leste.assertions")
local Utils = require("tests.utils")

Leste.it("possible to use strings", function()
	local output = Utils.runProgram('"Hello" show')

	Assertions.equal(output, "Hello")
end)

Leste.it("verify if strings can escape chars", function()
	local output = Utils.runProgram('"A \t B \n C" show')

	Assertions.equal(output, "A \t B \n C")
end)

Leste.it("verify if strings show error if is unclosed", function()
	local output = Utils.runProgram('"ABC show')

	Assertions.assert(output:find("Unclosed string."))
end)
