local Leste = require("leste.leste")
local Assertions = require("leste.assertions")
local Utils = require("tests.utils")

-- WHILE

Leste.it("should run while loops correctly", function()
	local output = Utils.runProgram('5 while dup 0 > do dup show 1 - end')

	Assertions.equal(output, "5\n4\n3\n2\n1")
end)

-- CONDITIONALS

Leste.it("should execute if statements correctly", function()
	local output = Utils.runProgram('if 1 1 = do "equal" show end')
	Assertions.equal(output, "equal")

	output = Utils.runProgram('if 1 2 = do "equal" show end')
	Assertions.equal(output, "")
end)

Leste.it("should execute if-else statements correctly", function()
	local output = Utils.runProgram('if 1 1 = do "equal" show else "not equal" show end')
	Assertions.equal(output, "equal")

	output = Utils.runProgram('if 1 2 = do "equal" show else "not equal" show end')
	Assertions.equal(output, "not equal")
end)
