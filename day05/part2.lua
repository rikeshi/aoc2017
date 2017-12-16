local input = {}

local f = io.open("input", r)

for line in f:lines() do
    input[#input+1] = tonumber(line)
end

f:close()

local n = 0
local i = 1
while input[i] do
    value = input[i]
    input[i] = value + (value >= 3 and -1 or 1)
    i = i + value
    n = n + 1
end

print(n)
