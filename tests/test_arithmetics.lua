local Leste = require("leste.leste")
local Assertions = require("leste.assertions")
local Utils = require("tests.utils")

-- PLUS

Leste.it("should add numbers correctly", function()
	local output = Utils.runProgram("1 1 + show")

	Assertions.equal(output, "2")
end)

Leste.it("should concatenate strings correctly", function()
	local output = Utils.runProgram('"a" "b" + show')

	Assertions.equal(output, "ab")
end)

Leste.it("should raise error when adding a number and a non-number", function()
	local output = Utils.runProgram('1 "a" + show')
	Assertions.assert(output:find("Error: Attempt to add a 'number' with a 'string'."))

	output = Utils.runProgram('1 1 2 = + show')
	Assertions.assert(output:find("Error: Attempt to add a 'number' with a 'boolean'."))

	output = Utils.runProgram('1 + show')
	Assertions.assert(output:find("Error: Attempt to add a 'nil' with a 'number'."))
end)

-- MINUS

Leste.it("should subtract numbers correctly", function()
	local output = Utils.runProgram("2 1 - show")

	Assertions.equal(output, "1")
end)

Leste.it("should raise error when subtracting a number and a non-number", function()
	local output = Utils.runProgram('1 "a" - show')
	Assertions.assert(output:find("Error: Attempt to sub a 'number' with a 'string'."))

	output = Utils.runProgram('1 1 2 = - show')
	Assertions.assert(output:find("Error: Attempt to sub a 'number' with a 'boolean'."))

	output = Utils.runProgram('1 - show')
	Assertions.assert(output:find("Error: Attempt to sub a 'nil' with a 'number'."))
end)

-- STAR

Leste.it("should multiply numbers correctly", function()
	local output = Utils.runProgram("2 1 * show")

	Assertions.equal(output, "2")
end)

Leste.it("should raise error when multiplying a number and a non-number", function()
	local output = Utils.runProgram('1 "a" * show')
	Assertions.assert(output:find("Error: Attempt to mul a 'number' with a 'string'."))

	output = Utils.runProgram('1 1 2 = * show')
	Assertions.assert(output:find("Error: Attempt to mul a 'number' with a 'boolean'."))

	output = Utils.runProgram('1 * show')
	Assertions.assert(output:find("Error: Attempt to mul a 'nil' with a 'number'."))
end)

-- SLASH

Leste.it("should divide numbers correctly", function()
	local output = Utils.runProgram("2 1 / show")

	Assertions.equal(output, "2.0")
end)

Leste.it("should raise error when dividing a number and a non-number", function()
	local output = Utils.runProgram('1 "a" / show')
	Assertions.assert(output:find("Error: Attempt to div a 'number' with a 'string'."))

	output = Utils.runProgram('1 1 2 = / show')
	Assertions.assert(output:find("Error: Attempt to div a 'number' with a 'boolean'."))

	output = Utils.runProgram('1 / show')
	Assertions.assert(output:find("Error: Attempt to div a 'nil' with a 'number'."))
end)

-- GREATER

Leste.it("should compare numbers correctly using greater than", function()
	local output = Utils.runProgram("2 2 > show")
	Assertions.equal(output, "false")

	local output = Utils.runProgram("3 2 > show")
	Assertions.equal(output, "true")
end)

Leste.it("should raise error when comparing a number and a non-number using greater than", function()
	local output = Utils.runProgram('2 "a" > show')
	Assertions.assert(output:find("Error: Attempt to compare 'number' with 'string'."))

	output = Utils.runProgram('2 1 1 = > show')
	Assertions.assert(output:find("Error: Attempt to compare 'number' with 'boolean'."))

	output = Utils.runProgram('2 > show')
	Assertions.assert(output:find("Error: Attempt to compare 'nil' with 'number'."))
end)

-- MOD

Leste.it("should calculate modulus correctly with numbers", function()
	local output = Utils.runProgram("10 2 % show")
	Assertions.equal(output, "0")

	local output = Utils.runProgram("10 3 % show")
	Assertions.equal(output, "1")
end)

Leste.it("should raise error when calculating modulus with a number and a non-number", function()
	local output = Utils.runProgram('2 "a" % show')
	Assertions.assert(output:find("Error: Attempt to mod a 'number' with a 'string'."))

	output = Utils.runProgram('2 1 1 = % show')
	Assertions.assert(output:find("Error: Attempt to mod a 'number' with a 'boolean'."))

	output = Utils.runProgram('2 % show')
	Assertions.assert(output:find("Error: Attempt to mod a 'nil' with a 'number'."))
end)


-- EQUAL

Leste.it("should compare equality correctly", function()
	local output = Utils.runProgram("2 2 = show")
	Assertions.equal(output, "true")

	local output = Utils.runProgram("3 2 = show")
	Assertions.equal(output, "false")
end)

-- NOT EQUAL

Leste.it("should compare inequality correctly", function()
	local output = Utils.runProgram("2 2 != show")
	Assertions.equal(output, "false")

	local output = Utils.runProgram("3 2 != show")
	Assertions.equal(output, "true")
end)
