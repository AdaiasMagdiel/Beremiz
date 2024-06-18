local Leste = require("leste.leste")
local Assertions = require("leste.assertions")
local Utils = require("tests.utils")

local files_output = {
	{"and_or", "true and true\ntrue or true\ntrue or false\ntrue or nil\nfalse or true\nnil or true"},
	{"and_while", "10 and 5 are not equal 15\n 11 and 6 are not equal 15\n 12 and 7 are not equal 15\n 13 and 8 are not equal 15\n 14 and 9 are not equal 15"},
	{"arithmetics", "ab\n4\n2\n3\n2.0\n3\n8.0\ntrue\nfalse\ntrue\nfalse"},
	{"conditional", "1 + 1 is equal 2\n1 + 1 is not equal 3\nThe number is 3"},
	{"definitions", "6"},
	{"factorial", "Factorial of 5 is 120"},
	{"fizzbuzz", "FizzBuzz up to: 15\n----------------\n\n1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\nFizz\nBuzz\n11\nFizz\n13\n14\nFizzBuzz"},
	{"hello_world", "Hello, world!"},
	{"include", "Values: 2, 1, 2, 1"},
	{"or_while", "10 and 5 are positive\n 9 and 4 are positive\n 8 and 3 are positive\n 7 and 2 are positive\n 6 and 1 are positive\n 5 and 0 are positive\n 4 and -1 are positive\n 3 and -2 are positive\n 2 and -3 are positive\n 1 and -4 are positive\n 0 and -5 are positive"},
	{"pythagorean_theorem", "5.0"},
	{"quadratic_equation", "Root 1: -3.0\nRoot 2: -2.0"},
	{"string_interpolation", "Num1: 1 | Num2: 2 | 1 + 2 = 3"},
	{"table_pop", "nil\nfalse\ntrue\ncaju\nbanana\nabacate\n3\n2\n1"},
	{"variables", "42\ndon't panic!"},
	{"while", "100\n98\n96\n94\n92\n90\n88\n86\n84\n82\n80\n78\n76\n74\n72\n70\n68\n66\n64\n62\n60\n58\n56\n54\n52\n50\n48\n46\n44\n42\n40\n38\n36\n34\n32\n30\n28\n26\n24\n22\n20\n18\n16\n14\n12\n10\n8\n6\n4\n2"},
}

for _, item in ipairs(files_output) do
	Leste.it(("test the '%s' example"):format(item[1]), function()
		local output = Utils.runFile(("examples/%s.brz"):format(item[1]))

		Assertions.equal(output, item[2])
	end)
end
