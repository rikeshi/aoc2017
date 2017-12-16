local nodes = {}
local has_parent = {}

local f = io.open("input", "r")

for line in f:lines() do
    local name, weight, children =
            line:match("(%l+)..(%d+)..?.?.?.?(.*)")

    nodes[name] = { weight, {} }

    array = nodes[name][2]
    for child in children:gmatch("%l+") do
        if not has_parent[child] then
            has_parent[child] = true
        end
        array[#array+1] = child
    end
end

f:close()

for name in pairs(nodes) do
    if not has_parent[name] then
        print(name)
        break
    end
end
