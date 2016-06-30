local json = require("cjson")
local luaml = require("luaml")

local file = io.open("luaml-scm-1.rockspec", "r")
local str = file:read("*a")
file:close()

local tmp1 = luaml.decode(str)
print(json.encode(tmp1))
local tmp2 = luaml.encode(tmp1)
print(tmp2)
local tmp3 = luaml.decode(tmp2)
print(json.encode(tmp3))

-- done!
