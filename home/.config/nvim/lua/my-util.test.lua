require("busted.runner")()

local util = require("my-util")

describe("util", function()
	assert.are.equal("IsModalVisible", util.upper_first_letter("isModalVisible"))
end)
