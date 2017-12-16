local opposites = {
    n  = "s" ,
    s  = "n" ,
    ne = "sw",
    sw = "ne",
    nw = "se",
    se = "nw"
}

local compounds = {
    n  = { se = "ne", sw = "nw" },
    s  = { ne = "se", nw = "sw" },
    ne = { nw = "n" , s  = "se" },
    nw = { ne = "n" , s  = "sw" },
    se = { sw = "s" , n  = "ne" },
    sw = { se = "s" , n  = "nw" }
}

local function remove_redundant(t)
    for i = 1, #t-1 do
        if t[i] ~= "_" then
            for j = i+1, #t do
                if t[j] ~= "_" then
                    if opposites[t[i]] == t[j] then
                        t[i], t[j] = "_", "_"
                        break
                    else
                        local direct = compounds[t[i]][t[j]]
                        if direct then
                            t[i], t[j] = "_", direct
                            break
                        end
                    end
                end
            end
        end
    end
    return t
end


local t = {}

local f = io.open("input", "r")
local line = f:read("*l")

for step in line:gmatch("%l+") do
    t[#t+1] = step
end

f:close()

t = remove_redundant(t)

local counts = {
    n  = 0,
    s  = 0,
    ne = 0,
    nw = 0,
    se = 0,
    sw = 0
}

for i = 1, #t do
    if t[i] ~= "_" then
        if not counts[t[i]] then
            counts[t[i]] = 1
        else
            counts[t[i]] = counts[t[i]] + 1
        end
    end
end

local answer = math.abs(counts.n  - counts.s )
             + math.abs(counts.ne - counts.sw)
             + math.abs(counts.nw - counts.se)

print(answer)
