local f = io.open("input", r)
local sum = 0

for line in f:lines() do
    for value1 in line:gmatch("%d+") do
        value1 = tonumber(value1)
        for value2 in line:gmatch("%d+") do
            value2 = tonumber(value2)
            if value1 ~= value2 then
                local div = value1 / value2
                if div == math.floor(div) then
                    sum = sum + div
                    break
                end
            end
        end
    end
end

f:close()

print(sum)


