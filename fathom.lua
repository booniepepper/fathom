Fathom = {}


function Fathom:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.stack = {}
    return o
end


function Fathom:repl()
    while true do
        local line = self:read()

        if line == nil then
            return
        end

        local tokens = self:parse(line)

        print(line)
    end
end


function Fathom:read()
    io.stdout:write("> ")
    io.stdout:flush()

    return io.read()
end


function Fathom:parse(code)
    local tokens = {}

    
    return code
end


return Fathom
