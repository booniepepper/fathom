Fathom = {
    stack = {},
    rules = {
        ['+'] = {
            type = 'rule',
            arity = 2,
            f = function(a, b)
                if a.type == 'number' and b.type == 'number' then
                    return { type = 'number', val = a.val + b.val }
                else
                    io.stderr:write("Unable to add non-numeric values\n")
                    os.exit(1)
                end
            end
        },
        ['_stack'] = {
            type = 'rule',
            arity = 'stack',
            f = function(stack)
                io.stdout:write("[ ")
                for i = 1, #stack do
                    local item = stack[i]
                    io.stdout:write(item.type .. "(" .. item.val .. ") ")
                end
                print("]")
            end
        }
    },
}


function Fathom:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.stack = self.stack or {}
    self.rules = self.rules or {}
    return o
end


function Fathom:repl(options)
    while true do
        local line = self.read()

        if line == nil then
            return
        end

        local tokens = self.parse(line)
        if options.tokens or options.debug then
            io.stderr:write("[PARSED...]\n")
            print_tokens(tokens)
        end

        self:eval(tokens)

        print(line)
    end
end


function Fathom.read()
    io.stdout:write("> ")
    io.stdout:flush()

    return io.read()
end


function Fathom.parse(code)
    local tokens = {}

    local i = 1

    while i <= #code do
        local whitespace = code:match('^[%s,]+', i)
        local string = code:match('^%b""', i) or code:match("^%b''", i)
        local number = code:match('^-?%d+%.?%d*', i)
        local symbol = code:match('^[%a_%-]+', i) or code:sub(i, i)

        if whitespace then
            -- discard
        elseif string then
            table.insert(tokens, { type = "string", val = string:sub(2, -2) })
        elseif number then
            table.insert(tokens, { type = "number", val = tonumber(number) })
        elseif symbol then
            table.insert(tokens, { type = "symbol", val = symbol })
        else
            table.insert(tokens, { type = "operator", val = operator })
        end
        
        local token = whitespace or string or number or int or symbol or operator

        i = i + #token
    end

    return tokens
end

function print_tokens(tokens)
    for i = 1, #tokens do
        local type = tokens[i].type
        local val = tokens[i].val
        io.stderr:write("[TOKEN] " .. val .. " (" .. type .. ")\n")
    end
end


function Fathom:eval(tokens)
    for i = 1, #tokens do
        local type = tokens[i].type
        local val = tokens[i].val
        local rule = self.rules[val]

        if rule then
            io.stderr:write("[RUN] " .. val .. "/" .. rule.arity .. "\n")
            if rule.arity == 'stack' then
                rule.f(self.stack)
            elseif rule.arity > #tokens then
                io.stderr:write("[ERROR] Stack underflow!!!")
                os.exit(1)
            elseif rule.arity == 2 then
                local b = table.remove(self.stack)
                local a = table.remove(self.stack)
                table.insert(self.stack, rule.f(a, b))                
            else
                print("I dunno know how to " .. val)
            end
        else
            table.insert(self.stack, { type = type, val = val })
        end
    end
end


return Fathom
