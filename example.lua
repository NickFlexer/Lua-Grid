---
-- example.lua


local Grid = require "grid"


function main()
    local grid = Grid(2, 5)
    grid:set_cell(2, 4, "B")
    print(grid:get_size())
    print(grid:get_cell(2, 4))
end

main()
