package = "luaml"
version = "scm-1"
source = {
    url = "git://github.com/dscoshpe/luaml",
    tag = "HEAD",
}
description = {
    summary = "A powerful markup language based on a subset of Lua.",
    detailed = [[
    ]],
    homepage = "https://github.com/dscoshpe/luaml",
    license = "MIT/X11"
}
dependencies = {
    "lua ~> 5.1"
}
build = {
    type = "builtin",
    modules = {
        ["luaml"] = "luaml.lua"
    }
}
