local function split(s)
    local t = {}
    for x in s:gmatch("%S+") do
        t[#t+1] = x
    end
    return t
end


local registers = {}

ops = {
    -- register operations
    inc = function(reg, n) return reg + n end,
    dec = function(reg, n) return reg - n end,

    -- relational operators
    ["=="] = function(a, b) return a == b end,
    ["!="] = function(a, b) return a ~= b end,
    [">" ] = function(a, b) return a >  b end,
    ["<" ] = function(a, b) return a <  b end,
    [">="] = function(a ,b) return a >= b end,
    ["<="] = function(a, b) return a <= b end
}


local f = io.open("input", "r")

for line in f:lines() do
    local fields = split(line)

    local reg0 = fields[1]
    local opr0 = fields[2]
    local val0 = tonumber(fields[3])
    local reg1 = fields[5]
    local opr1 = fields[6]
    local val1 = tonumber(fields[7])

    local cur0 = registers[reg0] or 0
    local cur1 = registers[reg1] or 0

    if ops[opr1](cur1, val1) then
        cur0 = ops[opr0](cur0, val0)
    end

    registers[reg0] = cur0
end

f:close()


local maximum = 0

for k, v in pairs(registers) do
    if v > maximum then maximum = v end
end

print(maximum)
