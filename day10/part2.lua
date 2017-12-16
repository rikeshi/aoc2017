local function reverse(t, i, n)
    local m = n >> 1
    n = n - 2
    for j = 0, m-1 do
        local pos1 = (i+j-1) % #t + 1
        local pos2 = (i+n-j) % #t + 1
        t[pos1], t[pos2] = t[pos2], t[pos1]
    end
end

local function to_dense_hash(sparse)
    local dense = {}
    for i = 0, 15 do
        dense[i+1] = sparse[i * 16 +  1]
                   ~ sparse[i * 16 +  2]
                   ~ sparse[i * 16 +  3]
                   ~ sparse[i * 16 +  4]
                   ~ sparse[i * 16 +  5]
                   ~ sparse[i * 16 +  6]
                   ~ sparse[i * 16 +  7]
                   ~ sparse[i * 16 +  8]
                   ~ sparse[i * 16 +  9]
                   ~ sparse[i * 16 + 10]
                   ~ sparse[i * 16 + 11]
                   ~ sparse[i * 16 + 12]
                   ~ sparse[i * 16 + 13]
                   ~ sparse[i * 16 + 14]
                   ~ sparse[i * 16 + 15]
                   ~ sparse[i * 16 + 16]
    end
    return dense
end


local lengths = {}

local f = io.open("input", "r")
local line = f:read("*l"):match("^%s*(.-)%s*$")
f:close()

for i = 1, #line do
    lengths[#lengths+1] = line:byte(i)
end
lengths[#lengths+1] = 17
lengths[#lengths+1] = 31
lengths[#lengths+1] = 73
lengths[#lengths+1] = 47
lengths[#lengths+1] = 23

local list = {}
for i = 0, 255 do
    list[i+1] = i
end

local position = 1
local skip_size = 0

for round = 1, 64 do
    for i = 1, #lengths do
        local length = lengths[i]
        if length > #list then
            print("length greater than list size: "..length)
        else
            reverse(list, position, length)
            position = (position + length + skip_size - 1) % #list + 1
            skip_size = skip_size + 1
        end
    end
end

local dense = to_dense_hash(list)

for i = 1, #dense do
    io.write(string.format("%02x", dense[i]))
end
print()
