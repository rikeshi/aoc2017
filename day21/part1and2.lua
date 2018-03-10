local function show_pattern(pat)
    local n = math.sqrt(#pat)
    for i = 0, n - 1 do
        for j = 1, n do
            io.write(pat[i*n+j] == 1 and '#' or '.')
        end
        io.write("\n")
    end
end


local function show_parts(parts)
    print("parts.shape = ["..#parts..","..#parts[1]..","..#parts[1][1].."]")
    for i = 1, #parts do
        for j = 1, #parts[i] do
            print("parts["..i.."]["..j.."]")
            show_pattern(parts[i][j])
            print()
        end
    end
end


local function to_pat(str)
    local pat = {}
    for i = 1, #str do
        local b = str:byte(i)
        if b ~= 47 then
            pat[#pat+1] = b == 35 and 1 or 0
        end
    end
    return pat
end

local function to_str(pat)
    local str = {}
    local n = math.sqrt(#pat)
    for i = 0, n - 1 do
        for j = 1, n do
            str[#str+1] = pat[i*n+j] == 1 and '#' or '.'
        end
        str[#str+1] = "/"
    end
    str[#str] = nil
    return table.concat(str)
end


local function rule_type(str)
    local n = 0
    for i = 1, #str do
        if str:byte(i) == 47 then n = n + 1 end
    end
    return n + 1
end


local function read_rules(fn)
    local rules = { [2] = {}, [3] = {} }
    for str in io.lines(fn) do
        local from, to = str:match('^(.-) => (.-)$');
        rules[rule_type(from)][from] = to
    end
    return rules
end


local function rotate(pat)
    local rot = {}
    local n = math.sqrt(#pat)
    for i = 0, n - 1 do
        for j = 1, n do
            rot[i*n+j] = pat[(n-j)*n+i+1]
        end
    end
    return rot
end


local function flip(pat)
    local n = math.sqrt(#pat)
    for i = 0, n - 1 >> 1 do
        for j = 1, n do
            local a = i * n + j
            local b = (n - i - 1) * n + j
            pat[a], pat[b] = pat[b], pat[a]
        end
    end
    return pat
end


local function is_match(pat, str)
    for i = 1, 2 do -- flip
        for j = 1, 4 do -- rotate
            if to_str(pat) == str then return true end
            pat = rotate(pat)
        end
        pat = flip(pat)
    end
    return false
end


local function split(pat, partsize)
    local parts = {}
    local size = math.sqrt(#pat)
    local nparts = size / partsize
    for i = 1, nparts do
        local ii = (i-1) * partsize * size
        if not parts[i] then parts[i] = {} end
        for j = 1, nparts do
            local jj = (j-1) * partsize
            if not parts[i][j] then parts[i][j] = {} end
            for k = 0, partsize - 1 do
                local kk = k * size
                for l = 1, partsize do
                    local a = k * partsize + l
                    local b = ii + jj + kk + l
                    parts[i][j][a] = pat[b]
                end
            end
        end
    end
    return parts
end


local function merge(parts)
    local pat = {}
    local partsize = math.sqrt(#parts[1][1])
    local nparts = #parts[1]
    for i = 1, nparts do
        for k = 0, partsize - 1 do
            for j = 1, nparts do
                for l = 1, partsize do
                    pat[#pat+1] = parts[i][j][k*partsize+l]
                end
            end
        end
    end
    return pat
end


local function apply_rules(rules, parts)
    for i = 1, #parts do
        for j = 1, #parts do
            for from, to in pairs(rules) do
                if is_match(parts[i][j], from) then
                    parts[i][j] = to_pat(to)
                    break
                end
            end
        end
    end
    return parts
end


local function count_on(pat)
    local count = 0
    for i = 1, #pat do
        if pat[i] == 1 then count = count + 1 end
    end
    return count
end


local function enhance(rules, grid)
    local size = math.sqrt(#grid)
    local rtype = size % 2 == 0 and 2 or 3
    local parts = split(grid, rtype)
    parts = apply_rules(rules[rtype], parts)
    return merge(parts)
end


-- main code starts here

if #arg ~= 1 then
    print("usage: "..arg[0].." <1/2>")
end

local n
if arg[1] == "1" then
    n = 5
elseif arg[1] == "2" then
    n = 18
else
    print("arg must be 1 or 2")
    os.exit(1)
end

local rules = read_rules("input")

local init = ".#./..#/###"
local grid = to_pat(init)

for i = 1, n do
    grid = enhance(rules, grid)
end

print(count_on(grid))

