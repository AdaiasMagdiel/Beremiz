local Leste = require("leste.leste")
local Assertions = require("leste.assertions")
local Utils = require("tests.utils")

-- WHILE

Leste.it("verify if while can run", function()
	local output = Utils.runProgram('5 while dup 0 > do dup show 1 - end')

	Assertions.equal(output, "5\n4\n3\n2\n1")
end)

-- CONDITIONALS

Leste.it("assert that if can compare bools", function()
	local output = Utils.runProgram('1 1 = if "equal" show end')
	Assertions.equal(output, "equal")

	output = Utils.runProgram('1 2 = if "equal" show end')
	Assertions.equal(output, "")
end)

Leste.it("assert that if-else can compare bools", function()
	local output = Utils.runProgram('1 1 = if "equal" show else "not equal" show end')
	Assertions.equal(output, "equal")

	output = Utils.runProgram('1 2 = if "equal" show else "not equal" show end')
	Assertions.equal(output, "not equal")
end)
