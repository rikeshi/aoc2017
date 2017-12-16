local f = io.open("input", "r")
local line = f:read("*l")
f:close()

local score_total = 0
local score_value = 1

local group_open  = string.byte('{')
local group_close = string.byte('}')
local escape_char = string.byte('!')
local trash_open  = string.byte('<')
local trash_close = string.byte('>')

local i = 1
while i <= #line do
    local byte = line:byte(i)

    if byte == group_open then
        score_total = score_total + score_value
        score_value = score_value + 1
    elseif byte == group_close then
        score_value = score_value - 1
    elseif byte == trash_open then
        while byte ~= trash_close do
            i = i + 1
            byte = line:byte(i)
            if byte == escape_char then
                i = i + 1
            end
        end
    end

    i = i + 1
end

print(score_total)
