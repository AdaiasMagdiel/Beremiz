local Leste = require("leste.leste")
local Assertions = require("leste.assertions")
local Utils = require("tests.utils")

-- DEFINE

Leste.it("should define a token", function()
	local output = Utils.runProgram('define a 1 end a 1 + show')

	Assertions.equal(output, "2")
end)

Leste.it("should works like a function", function()
	local output = Utils.runProgram('define square dup * end 5 square show')

	Assertions.equal(output, "25")
end)

Leste.it("should raise a error when not found a identifier", function()
	local output = Utils.runProgram('define dup * end 5 square show')

	Assertions.assert(output:find("Expected 'identifier'"))
end)

Leste.it("should raise a error when not define a identifier", function()
	local output = Utils.runProgram('5 square show')

	Assertions.assert(output:find("Undefined identifier"))
end)
