local function tokey(t)
    return table.concat(t, " ")
end

local function findmax(t)
    local index = 0
    local maximum = 0
    for i = 1, #t do
        if t[i] > maximum then
            maximum = t[i]
            index = i
        end
    end
    return index
end


local input = {}
local known = {}

local f = io.open("input", "r")

for value in f:read("*l"):gmatch("%d+") do
    input[#input+1] = tonumber(value)
end

f:close()


local n = 0
local loop_size

while true do
    local key = tokey(input)
    if known[key] then
        loop_size = n - known[key]
        break
    end
    known[key] = n

    local index = findmax(input)
    local cache = input[index]
    input[index] = 0

    while cache ~= 0 do
        index = index + 1
        if index > #input then index = 1 end
        input[index] = input[index] + 1
        cache = cache - 1
    end

    n = n + 1
end

print(loop_size)
