local f = io.open("input", "r")
local line = f:read("*l")

local group_open  = string.byte('{')
local group_close = string.byte('}')
local escape_char = string.byte('!')
local trash_open  = string.byte('<')
local trash_close = string.byte('>')

local trash_total = 0

local i = 1
while i <= #line do
    local byte = line:byte(i)
    
    if byte == trash_open then
        while byte ~= trash_close do
            i = i + 1
            byte = line:byte(i)
            if byte == escape_char then
                i = i + 1
            elseif byte ~= trash_close then
                trash_total = trash_total + 1
            end
        end
    end
   
   i = i + 1 
end

print(trash_total)
