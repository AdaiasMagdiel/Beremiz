local Leste = require("leste.leste")
local Assertions = require("leste.assertions")
local Utils = require("tests.utils")

-- Single Line

Leste.it("should use single line comments correctly", function()
	local output = Utils.runProgram("2 2 + show \n # 1 1 + show \n 3 3 + show")

	Assertions.equal(output, "4\n6")
end)

-- Multi-line

Leste.it("should use multi-line comments correctly", function()
	local output = Utils.runProgram("1 2 + #[\n 3 3 + \n * \n]# show")

	Assertions.equal(output, "3")
end)
