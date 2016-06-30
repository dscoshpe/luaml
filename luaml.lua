--[[
	A powerful markup language based on a subset of Lua.
--]]

local LuaML = {
	debug = true
}

-- just a placeholder
local function loadLuaML()
end

-- use the 'load()' function
local function loadSafe(str)
	local result = {}
	local chunk, err = load(str, nil, "t", result)
	if chunk ~= nil then
		local ran, err = pcall(chunk)
		if ran then
			return result
		end
	end
	return nil
end

-- use the 'loadstring()' function
local function load51(str)
	local result = {}
	local chunk, err = loadstring(str)
	if chunk ~= nil then
		setfenv(chunk, result)
		local ran, err = pcall(chunk)
		if ran then
			return result
		end
	end
	return nil
end

local function exportLuaML(tbl, lvl)
	local out = {}
	lvl = lvl or 1
	local tabs = string.rep("\t", lvl - 1)

	-- traverse every element in the table at this level
	for k,v in pairs(tbl) do

		-- format the key
		local t = type(k)
		if lvl > 1 then
			if t == "number" then
				k = string.format("[%d]", k)
			elseif t == "string" then
				k = string.format("[%q]", k)
			else
				printDebug(string.format("Ignoring unsupported key type '%s'.", t))
			end
		end

		-- format the value
		local t = type(v)
		if t == "number" then
			table.insert(out, string.format("%s%s = %s", tabs, k, v))
		elseif t == "string" or t == "boolean" then
			table.insert(out, string.format('%s%s = %q', tabs, k, v))
		elseif t == "table" then -- recurse
			table.insert(out, string.format("%s%s = %s", tabs, k, exportLuaML(v, lvl + 1)))
		else -- function, userdata, pattern, etc. just ignore
			printDebug(string.format("Ignoring unsupported value type '%s'.", t))
		end
	end

	if lvl == 1 then return table.concat(out, ";\n") end
	return string.format("{\n%s\n%s}", table.concat(out, ",\n"), string.rep("\t", lvl - 2))
end


local function printDebug(str)
	if LuaML.debug then print(str) end
end

--[[
Lua 5.2 and LuaJIT support code loading via the 'load()' function which is
safer than the 'loadstring()' function in Lua 5.1. Since the '_VERSION'
variable is not a reliable indicator, particularly when using LuaJIT, just test
the function to determine which method to use.
--]]
local function testLoadMethod()
	if pcall(load, "foo") == false then
		printDebug("Setting 5.1 string loading mode.")
		loadLuaML = load51
		loadSafe = nil
		return "load"
	else
		printDebug("Setting safe string loading mode.")
		loadLuaML = loadSafe
		load51 = nil
		return "loadstring"
	end
	return false
end

-- a convenient reference to the decode mode currently in use
LuaML.method = testLoadMethod()

-- table -> string
function LuaML.encode(tbl)
	return exportLuaML(tbl)
end

-- string -> table
function LuaML.decode(str)
	str = str:gsub("^#![^\n]*\n", "")
	return loadLuaML(str)
end

return LuaML
