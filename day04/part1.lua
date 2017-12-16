local sum = 0

local f = io.open("input", "r")

for line in f:lines() do
    local t = {}
    for word in line:gmatch("%l+") do
        if t[word] then
            sum = sum - 1
            break
        end
        t[word] = true
    end
    sum = sum + 1
end

f:close()

print(sum)
