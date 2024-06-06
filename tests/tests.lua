local Leste = require("leste.leste")
local Utils = require("tests.utils")

Leste.beforeAll = function()
	Utils.mkdir("tests/.temp")
end

Leste.afterAll = function()
	Utils.clearDir("tests/.temp")
end
