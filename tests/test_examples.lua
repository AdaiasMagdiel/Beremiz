local Leste = require("leste.leste")
local Assertions = require("leste.assertions")
local Utils = require("tests.utils")

Leste.it("test the and_or example", function()
	local output = Utils.runFile("examples/and_or.brz")

	Assertions.equal(output, "true and true\ntrue or true\ntrue or false\ntrue or nil\nfalse or true\nnil or true")
end)

Leste.it("test the and_while example", function()
	local output = Utils.runFile("examples/and_while.brz")

	Assertions.equal(output, "10 and 5 are not equal 15\n 11 and 6 are not equal 15\n 12 and 7 are not equal 15\n 13 and 8 are not equal 15\n 14 and 9 are not equal 15")
end)

Leste.it("test the arithmetics example", function()
	local output = Utils.runFile("examples/arithmetics.brz")

	Assertions.equal(output, "ab\n4\n2\n3\n2.0\n3\n8.0\ntrue\nfalse\ntrue\nfalse")
end)

Leste.it("test the conditional example", function()
	local output = Utils.runFile("examples/conditional.brz")

	Assertions.equal(output, "1 + 1 is equal 2\n1 + 1 is not equal 3\nThe number is 3")
end)

Leste.it("test the definitions example", function()
	local output = Utils.runFile("examples/definitions.brz")

	Assertions.equal(output, "6")
end)

Leste.it("test the factorial example", function()
	local output = Utils.runFile("examples/factorial.brz")

	Assertions.equal(output, "Factorial of 5 is 120")
end)

Leste.it("test the hello_world example", function()
	local output = Utils.runFile("examples/hello_world.brz")

	Assertions.equal(output, "Hello, world!")
end)

Leste.it("test the include example", function()
	local output = Utils.runFile("examples/include.brz")

	Assertions.equal(output, "Values: 2, 1, 2, 1")
end)

Leste.it("test the or_while example", function()
	local output = Utils.runFile("examples/or_while.brz")

	Assertions.equal(output, "10 and 5 are positive\n 9 and 4 are positive\n 8 and 3 are positive\n 7 and 2 are positive\n 6 and 1 are positive\n 5 and 0 are positive\n 4 and -1 are positive\n 3 and -2 are positive\n 2 and -3 are positive\n 1 and -4 are positive\n 0 and -5 are positive")
end)

Leste.it("test the pythagorean_theorem example", function()
	local output = Utils.runFile("examples/pythagorean_theorem.brz")

	Assertions.equal(output, "5.0")
end)

Leste.it("test the quadratic_equation example", function()
	local output = Utils.runFile("examples/quadratic_equation.brz")

	Assertions.equal(output, "Root 1: -3.0\nRoot 2: -2.0")
end)

Leste.it("test the string_interpolation example", function()
	local output = Utils.runFile("examples/string_interpolation.brz")

	Assertions.equal(output, "Num1: 1 | Num2: 2 | 1 + 2 = 3")
end)

Leste.it("test the while example", function()
	local output = Utils.runFile("examples/while.brz")

	Assertions.equal(output, "100\n98\n96\n94\n92\n90\n88\n86\n84\n82\n80\n78\n76\n74\n72\n70\n68\n66\n64\n62\n60\n58\n56\n54\n52\n50\n48\n46\n44\n42\n40\n38\n36\n34\n32\n30\n28\n26\n24\n22\n20\n18\n16\n14\n12\n10\n8\n6\n4\n2")
end)
