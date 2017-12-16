local function reverse(t, i, n)
    local m = n >> 1
    n = n - 2
    for j = 0, m do
        local pos1 = (i+j-1) % #t + 1
        local pos2 = (i+n-j) % #t + 1
        t[pos1], t[pos2] = t[pos2], t[pos1]
    end
end


local lengths = {}

local f = io.open("input", "r")
local line = f:read("*l")
f:close()

for n in line:gmatch("%d+") do
    lengths[#lengths+1] = tonumber(n)
end

local list = {}
for i = 0, 255 do
    list[i+1] = i
end

local position = 1
local skip_size = 0

for i = 1, #lengths do
    local length = lengths[i]
    if length > #list then
        print("length greater than list size: "..length)
    else
        reverse(list, position, length)
        position = (position + length + skip_size) % #list
        skip_size = skip_size + 1
    end
end

print(list[1] * list[2])

