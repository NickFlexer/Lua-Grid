---
-- example.lua


local Grid = require "grid"


function main()
    local grid = Grid(2, 5, "X")
    grid:set_cell(2, 4, "O")

    local size_x, size_y = grid:get_size()

    for x, _, cell in grid:iterate() do
        io.write(tostring(cell) .. " ")

        if x == size_x then
            io.write("\n")
        end
    end

    for d_x, d_y, cell in grid:iterate_neighbor(1, 1) do
        print(d_x, d_y, cell)
    end
end

main()
