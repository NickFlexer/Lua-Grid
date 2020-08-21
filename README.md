Grid Class for Games or whatever else you can think of.

By Randy Carnahan, released to the Public Domain.

The Grid object is data agnostic.  It doesn't care what kind of data you store in a cell. This is meant to be, for abstraction's sake. You could even store functions.

The class defines -no- display methods. Either sub-class the Grid class to add your own, or define functions that call the get_cell() method.

Grid coordinates are always x,y number pairs. X is the vertical, starting at the top left, and Y is the horizontal, also starting at the top left. Hence, the top-left cell is always 1,1. One cell to the right is 2,1. One cell down is 1,2.

Usage:

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

Documentation

get_size()
get_default_value()
iterate()
iterate_neighbor(x, y)
is_valid(x, y)             Checks to see if a given cell is within the grid.
get_cell(x, y)             Gets the cell's data.
get_cells(cells)           Gets a set of data for x,y pairs in table 'cells'.
set_cell(x, y, obj)        Sets the cell's data to the given object.
reset_cell(x, y)           Resets the cell to the default data.
reset_all()                Resets the entire grid to the default data.
populate(data)             Given a data-filled table, will set multiple cells.
get_contents(no_default)   Returns a flat table of data suitable for populate()
get_vector(vector)         Translates a GRID_* vector into a x,y vector pair.
get_neighbor(x, y, vector) Gets a x,y's neighbor in vector direction.
get_neighbors(x, y)        Returns a table of the given's cell's 8 neighbors.
resize(newx, newy)         Resizes the grid. Can lose data if new grid is smaller.
get_row(x)                 Gets the row for the given x value.
get_column(y)              Gets the column for the given y value
traverse(x, y, vector)     Returns all cells start at x,y in vector direction.
