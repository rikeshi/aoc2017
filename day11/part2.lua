-- the internet helped out

local abs = math.abs
local max = math.max

local steps = {
    n  = function(x, y) return x  , y+2 end,
    ne = function(x, y) return x+1, y+1 end,
    nw = function(x, y) return x-1, y+1 end,
    s  = function(x, y) return x  , y-2 end,
    se = function(x, y) return x+1, y-1 end,
    sw = function(x, y) return x-1, y-1 end
}

local x = 0
local y = 0

local max_dist = 0

local f = io.open("input", "r")
local line = f:read("*l")

for step in line:gmatch("%l+") do
    x, y = steps[step](x, y)
    local dist = max(abs(x), abs(y), -abs(x - y))
    max_dist = max(max_dist, dist)
end

f:close()

print(max_dist)
