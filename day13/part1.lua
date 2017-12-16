local f = io.open("input", "r")

local sev = 0
for line in f:lines() do
    local l, d = line:match("^(%d+): (%d+)$")
    local l = tonumber(l)
    local d = tonumber(d)
    -- layer position modulo scanner cycle
    if l % (2 * d - 2) == 0 then
        sev = sev + l * d
    end
end

f:close()

print(sev)
