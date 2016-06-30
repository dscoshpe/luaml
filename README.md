# LuaML

A powerful markup language based on a subset of Lua.

## Why?

I use Lua frequently. I also use configuration files frequently. I find it makes perfect sense to write configuration files as a Lua table that I can then import and parse with a simple `dofile()`.

The Lua language is nice for this, it supports:
* multi-line strings
* dangling list separators
* inline *and* block comments
* lists and maps
* single quotes, double quotes, *and more!*

Best of all, the language is already well-defined. So, I threw this module together to keep things DRY on my end.

## How?

This version of LuaML is based on the [LuaRocks](https://github.com/keplerproject/luarocks) `Rockspec` format. For decoding it uses a similar convention to that of `luarocks` which relies on the Lua `load()` and `loadstring()` functions, depending on the version of Lua in use. For encoding it uses a pure Lua recursive table walking function which serializes applicable entries. The LuaML produced by the encoder uses language features which are a little more explicit than what a `Rockspec` may contain so it will look different. Both flavors are perfectly valid however.

## Usage

``` lua
local luaml = require("luaml")

local config_text = [=[
-- yay, comments
package = "sample config"
version = 1.0
description = [[
	Showing off one way to do 
	multi-line strings support.
]]
-- a fun hierarchical structure
config = {
	module1 = {
		-- this one is treated like a map
		key1 = "value1",
		key2 = "value2", -- let the separator dangle, its ok!
	},
	module2 = {
		-- this one is treated like a list
		"enum1", "enum2", "enum3", "enum4",
		key = "but it can have map elements too"
	}
}
]=]

-- lets decode from LuaML
local config_obj = luaml.decode(config_text)

-- lets encode to LuaML
print(luaml.encode(config_obj))

-- done!
```

# TODO

- [ ] add test procedure script
- [ ] formal LuaML specification
