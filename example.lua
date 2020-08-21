---
-- example.lua


local Grid = require "grid"


local grid = Grid(5, 3, "X")
grid:set_cell(2, 2, "O")

local size_x, size_y = grid:get_size()

print("Grid size: X = " .. tostring(size_x) .. " Y = " .. tostring(size_y))
print("\n")
print("Grid content is:")

for x, _, cell in grid:iterate() do
    io.write(tostring(cell) .. " ")

    if x == size_x then
        io.write("\n")
    end
end
