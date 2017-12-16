local input = 277678

-- http://oeis.org/A033996
-- 4 * n * (n + 1)
-- start from 1 instead of 0, so subtract 1 from input
-- input - 1 == 4 * n * (n + 1)
local n_plus_one = math.ceil(math.sqrt((input - 1) / 4))
local max_distance = (n_plus_one - 1) * 2
local max_value = max_distance * (max_distance + 2)
local position = (max_value - (input - 1)) % max_distance
local answer = math.abs(position - (max_distance / 2)) + n_plus_one - 1

print(answer)
