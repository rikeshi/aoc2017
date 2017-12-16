local f = io.open("input", r)
local sum = 0

for line in f:lines() do
    local lo = math.huge
    local hi = 0
    for value in line:gmatch("%d+") do
        value = tonumber(value)
        if value < lo then lo = value end
        if value > hi then hi = value end
    end
    sum = sum + (hi - lo)
end

f:close()

print(sum)
