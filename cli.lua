CLI = {}

function CLI.help(f)
    f:write("Usage: fathom [FLAGS]\n")
end

function CLI.flags()
    local flags = {}

    for i = 1, #arg do
        local a = arg[i]

        if a == "--tokens" then
            flags.tokens = true
        elseif a == "--debug" then
            flags.debug = true
        elseif a == "--help" or a == "-h" then
            flags.help = true
        end
    end

    return flags
end

return CLI
