local layers = {}

local function collision_test(layers, picos)
    for i = 1, #layers do
        local l = layers[i][1]
        local d = layers[i][2]
        local x = 2 * d - 2
        if (l + picos) % x == 0 then
            return true
        end
    end
    return false
end

local f = io.open("input", "r")

for line in f:lines() do
    local l, d = line:match("^(%d+): (%d+)$")
    local l = tonumber(l)
    local d = tonumber(d)
    layers[#layers+1] = { l, d }
end

f:close()

local picos = 0
while true do
    local collision = collision_test(layers, picos)
    if not collision then break end
    picos = picos + 1
end

print(picos)


