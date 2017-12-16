local nodes = {}
local has_parent = {}


local function add_weights(node)
    for _, child in ipairs(node[5]) do
        node[3] = node[3] + add_weights(child)
    end

    return node[2] + node[3]
end


local function find_index(t)
    local w1 = t[1][2] + t[1][3]
    if t[2] then
        local w2 = t[2][2] + t[2][3]
        if w1 ~= w2 then
            if t[3] then
                local w3 = t[3][2] + t[3][3]
                return w1 ~= w3 and 1 or 2
            end
            return 1
        end
    else
        for i = 3, #t do
            local wi = t[i][2] + t[i][3]
            if w1 ~= wi then return i end
        end
    end
end


local found = false

local function correct_weight(node)
    local children = node[5]
    if #children ~= 0 then
        local index = find_index(children)
        if index then
            local culprit = children[index]

            correct_weight(culprit)

            local reference = children[index+1]
                           or children[index-1]

            local wrong = culprit[2] + culprit[3]
            local right = reference[2] + reference[3]
            local corrected = culprit[2] - (wrong - right)
            print(corrected)
            -- program complete, exit
            os.exit(0)
        end
        if not found then
            for i = 1, #children do
                correct_weight(children[i])
            end
        end
    end
end


local function find_root(nodes)
    for name in pairs(nodes) do
        if not has_parent[name] then
            return name
        end
    end
end


local f = io.open("input", "r")

for line in f:lines() do
    local name, weight, children =
            line:match("(%l+)..(%d+)..?.?.?.?(.*)")

    local node = nodes[name]
    if not node then
        nodes[name] = {}
        node = nodes[name]
    end
    node[1] = name
    node[2] = tonumber(weight)
    node[3] = 0
    node[4] = {}
    node[5] = {}

    local ch_names = node[4]
    local ch_nodes = node[5]
    for child in children:gmatch("%l+") do
        if not has_parent[child] then
            has_parent[child] = true
        end

        if not nodes[child] then
            nodes[child] = {}
        end

        ch_names[#ch_names+1] = child
        ch_nodes[#ch_nodes+1] = nodes[child]
    end
end

f:close()

local root = find_root(nodes)

add_weights(nodes[root])
correct_weight(nodes[root])

