local function split(s)
    local t = {}
    for x in s:gmatch("%S+") do
        t[#t+1] = x
    end
    return t
end

local registers = {}

local ops = {}

-- register operations
ops.inc = function(reg, n) return reg + n end
ops.dec = function(reg, n) return reg - n end

-- relational operators
ops["=="] = function(a, b) return a == b end
ops["!="] = function(a, b) return a ~= b end
ops[">" ] = function(a, b) return a >  b end
ops["<" ] = function(a, b) return a <  b end
ops[">="] = function(a ,b) return a >= b end
ops["<="] = function(a, b) return a <= b end


local max_during = 0

local f = io.open("input", "r")

for line in f:lines() do
    local fields = split(line)

    local reg = fields[1]
    local op = fields[2]
    local mod_val = fields[3]
    local cmp_reg = fields[5]
    local cmp_op = fields[6]
    local cmp_val = tonumber(fields[7])

    local reg_val = registers[reg] or 0
    local cmp_reg_val = registers[cmp_reg] or 0

    if ops[cmp_op](cmp_reg_val, cmp_val) then
        reg_val = ops[op](reg_val, mod_val)
    end
    registers[reg] = reg_val
    if reg_val > max_during then max_during = reg_val end
end

f:close()

print(max_during)
