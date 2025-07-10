local Fathom = require("fathom")
local CLI = require("cli")

print("fathom 0.0")

local fathom = Fathom:new()
local flags = CLI.flags()

if flags.help then
    CLI.help(io.stdout)
    return
end

fathom:repl(flags)
