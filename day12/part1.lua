local programs = {}
local group_0 = {}
local size = 0

local function recurse(prog)
    group_0[prog] = true
    size = size + 1
    local ids = programs[prog]
    for i = 1, #ids do
        if not group_0[ids[i]] then
            recurse(ids[i])
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

recurse("0")

print(size)
