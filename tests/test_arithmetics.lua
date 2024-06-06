local Leste = require("leste.leste")
local Assertions = require("leste.assertions")
local Utils = require("tests.utils")

-- PLUS

Leste.it("possible to add numbers", function()
	local output = Utils.runProgram("1 1 + show")

	Assertions.equal(output, "2")
end)

Leste.it("possible to concant strings", function()
	local output = Utils.runProgram('"a" "b" + show')

	Assertions.equal(output, "ab")
end)

Leste.it("raise error if try to add number and not number", function()
	local output = Utils.runProgram('1 "a" + show')
	Assertions.assert(output:find("Error: Attempt to add a 'number' with a 'string'."))

	output = Utils.runProgram('1 1 2 = + show')
	Assertions.assert(output:find("Error: Attempt to add a 'number' with a 'boolean'."))

	output = Utils.runProgram('1 + show')
	Assertions.assert(output:find("Error: Attempt to add a 'nil' with a 'number'."))
end)

-- MINUS

Leste.it("possible to sub numbers", function()
	local output = Utils.runProgram("2 1 - show")

	Assertions.equal(output, "1")
end)

Leste.it("raise error if try to sub number and not number", function()
	local output = Utils.runProgram('1 "a" - show')
	Assertions.assert(output:find("Error: Attempt to sub a 'number' with a 'string'."))

	output = Utils.runProgram('1 1 2 = - show')
	Assertions.assert(output:find("Error: Attempt to sub a 'number' with a 'boolean'."))

	output = Utils.runProgram('1 - show')
	Assertions.assert(output:find("Error: Attempt to sub a 'nil' with a 'number'."))
end)

-- STAR

Leste.it("possible to mul numbers", function()
	local output = Utils.runProgram("2 1 * show")

	Assertions.equal(output, "2")
end)

Leste.it("raise error if try to mul number and not number", function()
	local output = Utils.runProgram('1 "a" * show')
	Assertions.assert(output:find("Error: Attempt to mul a 'number' with a 'string'."))

	output = Utils.runProgram('1 1 2 = * show')
	Assertions.assert(output:find("Error: Attempt to mul a 'number' with a 'boolean'."))

	output = Utils.runProgram('1 * show')
	Assertions.assert(output:find("Error: Attempt to mul a 'nil' with a 'number'."))
end)

-- SLASH

Leste.it("possible to div numbers", function()
	local output = Utils.runProgram("2 1 / show")

	Assertions.equal(output, "2.0")
end)

Leste.it("raise error if try to div number and not number", function()
	local output = Utils.runProgram('1 "a" / show')
	Assertions.assert(output:find("Error: Attempt to div a 'number' with a 'string'."))

	output = Utils.runProgram('1 1 2 = / show')
	Assertions.assert(output:find("Error: Attempt to div a 'number' with a 'boolean'."))

	output = Utils.runProgram('1 / show')
	Assertions.assert(output:find("Error: Attempt to div a 'nil' with a 'number'."))
end)

-- GREATER

Leste.it("verify if greather can be compare numbers", function()
	local output = Utils.runProgram("2 2 > show")
	Assertions.equal(output, "false")

	local output = Utils.runProgram("3 2 > show")
	Assertions.equal(output, "true")
end)

Leste.it("assert that greather can be only used with numbers", function()
	local output = Utils.runProgram('2 "a" > show')
	Assertions.assert(output:find("Error: Attempt to compare 'number' with 'string'."))

	output = Utils.runProgram('2 1 1 = > show')
	Assertions.assert(output:find("Error: Attempt to compare 'number' with 'boolean'."))

	output = Utils.runProgram('2 > show')
	Assertions.assert(output:find("Error: Attempt to compare 'nil' with 'number'."))
end)


-- EQUAL

Leste.it("verify if equal can compare correctly", function()
	local output = Utils.runProgram("2 2 = show")
	Assertions.equal(output, "true")

	local output = Utils.runProgram("3 2 = show")
	Assertions.equal(output, "false")
end)

-- MOD

Leste.it("verify if mod can be used with numbers", function()
	local output = Utils.runProgram("10 2 % show")
	Assertions.equal(output, "0")

	local output = Utils.runProgram("10 3 % show")
	Assertions.equal(output, "1")
end)

Leste.it("assert that mod can be only used with numbers", function()
	local output = Utils.runProgram('2 "a" % show')
	Assertions.assert(output:find("Error: Attempt to mod a 'number' with a 'string'."))

	output = Utils.runProgram('2 1 1 = % show')
	Assertions.assert(output:find("Error: Attempt to mod a 'number' with a 'boolean'."))

	output = Utils.runProgram('2 % show')
	Assertions.assert(output:find("Error: Attempt to mod a 'nil' with a 'number'."))
end)
