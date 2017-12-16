local sum = 0

local function is_valid(words)
    for i = 1, #words-1 do
        for j = i+1, #words do
            local found = true
            if #words[i] == #words[j] then
                local chars = {}

                for k = 1, #words[i] do
                    local ci = words[i]:byte(k)
                    local cj = words[j]:byte(k)

                    if not chars[ci] then chars[ci] = 0 end
                    if not chars[cj] then chars[cj] = 0 end

                    chars[ci] = chars[ci] + 1
                    chars[cj] = chars[cj] - 1
                end

                for _, n in pairs(chars) do
                    if n ~= 0 then
                        found = false
                        break
                    end
                end

                if found then
                    -- invalid
                    return 0
                end
            end
        end
    end
    -- valid
    return 1
end

local f = io.open("input", "r")

for line in f:lines() do
    local words = {}

    for word in line:gmatch("%l+") do
        words[#words+1] = word
    end

    sum = sum + is_valid(words)
end

f:close()

print(sum)
