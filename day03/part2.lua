-- function that expands the grid by one layer
local function expand_grid(grid)
    grid.size = grid.size + 1
    grid[-grid.size] = {}
    grid[grid.size] = {}
end

-- function that sums all the neighors
local function sum_neighbors(grid, i, j)
    local a = grid[i-1][j-1] or 0
    local b = grid[i-1][j  ] or 0
    local c = grid[i-1][j+1] or 0
    local d = grid[i  ][j-1] or 0
    local e = grid[i  ][j+1] or 0
    local f = grid[i+1][j-1] or 0
    local g = grid[i+1][j  ] or 0
    local h = grid[i+1][j+1] or 0
    return a + b + c + d + e + f + g + h
end


do

    local input = 277678

    -- the grid to traverse in a spiral
    local grid = {}
    -- intitialize grid
    grid[0] = {}
    grid[0][0] = 1
    grid.size = 0
    expand_grid(grid)
    expand_grid(grid)

    local steps = 1
    local n = 2
    local last_step = n * (n + 2)
    local layer = 1

    -- indices of the next value in the grid
    local i = 1
    local j = 0

    -- increment values
    local i_inc = 0
    local j_inc = -1

    while true do

        if i == layer and j == -layer then
            i_inc = -1
            j_inc = 0
        elseif i == -layer and j == -layer then
            i_inc = 0
            j_inc = 1
        elseif i == -layer and j == layer then
            i_inc = 1
            j_inc = 0
        end

        -- set the next value
        grid[i][j] = sum_neighbors(grid, i, j)
        if grid[i][j] > input then
            break
        end

        i = i + i_inc
        j = j + j_inc

        -- check if the grid should be expanded
        if steps == last_step then
            expand_grid(grid)
            -- calculate the last step for the next layer
            n = n + 2
            last_step = n * (n + 2)
            -- next layer
            layer = layer + 1

            -- reset the increments
            i_inc = 0
            j_inc = -1
        end

        steps = steps + 1

    end

    -- print the answer
    print(grid[i][j])

end
