local particle
local slowest = math.huge
local i = 0

for line in io.lines("input") do
    local ax, ay, az = line:match('a=<(.-),(.-),(.-)>')
    local sum = math.abs(ax) + math.abs(ay) + math.abs(az)
    if sum < slowest then
        slowest = sum
        particle = i
    end
    i = i + 1
end

print("particle: ", particle)
