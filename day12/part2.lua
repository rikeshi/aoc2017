local programs = {}
local has_group = {}
local n = 0

local function recurse(prog)
    has_group[prog] = true
    local ids = programs[prog]
    for i = 1, #ids do
        if not has_group[ids[i]] then
            recurse(ids[i], group)
        end
    end
end


local f = io.open("input", "r")

for line in f:lines() do
    local prog, rest = line:match("(%d+) <%-> (.+)")
    local ids = {}
    for id in rest:gmatch("%d+") do
        ids[#ids+1] = id
    end
    programs[prog] = ids
end

f:close()

for k, v in pairs(programs) do
    if not has_group[k] then
        has_group[k] = true
        n = n + 1
    end
    for i = 1, #v do
        recurse(v[i])
    end
end

print(n)

