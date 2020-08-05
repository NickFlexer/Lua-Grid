---
-- grid.lua


local Grid = {
    direction = {
        GRID_TOP_LEFT = {-1, -1},
        GRID_TOP = {0, -1},
        GRID_TOP_RIGHT = {1, -1},
        GRID_LEFT = {-1, 0},
        GRID_CENTER = {0, 0},
        GRID_RIGHT = {1, 0},
        GRID_BOTTOM_LEFT = {-1 , 1},
        GRID_BOTTOM = {0, 1},
        GRID_BOTTOM_RIGHT = {1, 1}
    }
}
local Grid_mt = {__index = Grid}

function Grid:new(size_x, size_y, def_value)
    if not size_x or type(size_x) ~= "number" or size_x < 1 or not size_y or type(size_y) ~= "number" or size_y < 1 then
        error("Grid: size_x and size_y must be a number values equal or greater than 1")
    end

    self.size_x = size_x
    self.size_y = size_y
    self.default_value = def_value or nil
    self._grid = {}

    for y = 1, self.size_y   do
        for x = 1, self.size_x do
            self._grid[(x - 1) * self.size_x + y] = self.default_value
        end
    end

    local gr = setmetatable({}, Grid_mt)

    return gr
end

function Grid:get_size()
    return self.size_x, self.size_y
end

function Grid:get_default_value()
    return self.default_value
end

--[[
-- This checks to see if a given x,y pair are within
-- the boundries of the grid.
--]]
function Grid:is_valid(x, y)
    if x == nil or type(x) ~= "number" or y == nil or type(y) ~= "number" then
        return false
    end

    if 0 < x and x <= self.size_x and 0 < y and y <= self.size_y then
        return true
    else
        return false
    end
end

--[[ Gets the data in a given x,y cell. ]]
function Grid:get_cell(x, y)
    if self:is_valid(x, y) then
        return self._grid[(x - 1) * self.size_x + y]
    else
        error("Grid: try to get cell by invalid index [ " .. tostring(x) .. " : " .. tostring(y) .. "]")
    end
end

--[[
-- This method will return a set of cell data in a table.
-- The 'cells' argument should be a table of x,y pairs of
-- the cells being requested.
--]]
function Grid:get_cells(cells)
    local data = {}

    local x, y, obj

    if type(cells) ~= "table" then
        return data
    end

    for _, v in ipairs(cells) do
        x, y = table.unpack(v)

        if self:is_valid(x, y) then
            table.insert(data, self:get_cell(x, y))
        end
    end

    return data
end

--[[ Sets a given x,y cell to the data object. ]]
function Grid:set_cell(x, y, obj)
    if self:is_valid(x, y) then
        self._grid[(x - 1) * self.size_x + y] = obj
    end
end

--[[ Resets a given x,y cell to the grid default value. ]]
function Grid:reset_cell(x, y)
    if self:is_valid(x, y) then
        self:set_cell(x, y, self.default_value)

        return true
    else
        return false
    end
end

--[[ Resets the entire grid to the default value. ]]
function Grid:reset_all()
    for y = 1, self.size_y do
        for x = 1, self.size_x do
            self:set_cell(x, y, self.default_value)
        end
    end
end

--[[
-- This method is used to populate multiple cells at once.
-- The 'data' argument must be a table, with each element
-- consisting of three values: x, y, and the data to set
-- the cell too. IE:
--   d = {{4, 4, "X"}, {4, 5, "O"}, {5, 4, "O"}, {5, 5, "X"}}
--   G:populate(d)
-- If the object to be populated is nil, it is replaced with
-- the default value.
--]]
function Grid:populate(data)
    if type(data) ~= "table" then return false end

    for i, v in ipairs(data) do
        local x, y, obj = table.unpack(v)

        if self:is_valid(x, y) then
            if obj == nil then 
                obj = self.default_value
            end

            self:set_cell(x, y, obj)
        end
    end

    return true
end

--[[
-- This method returns the entire grid's contents in a
-- flat table suitable for feeding to populate() above.
-- Useful for recreating a grid layout.
-- If the 'no_default' argument is non-nil, then the
-- returned data table only contains elements who's 
-- cells are not the default value.
--]]
function Grid:get_contents(no_default)
    local data     = {}
    local cell_obj = nil

    for x = 1, self.size_x do
        for y = 1, self.size_y do
            cell_obj = self:get_cell(x, y)

            if no_default == true and cell_obj == self.def_value then
                -- Do nothing, ignore default values.
            else
                table.insert(data, {x, y, cell_obj})
            end
        end
    end

    return data
end

--[[ Gets a cell's neighbor in a given vector. ]]
function Grid:get_neighbor(x, y, vector)
    local obj    = nil
    local vx, vy = table.unpack(vector)

    if vx ~= nil then
        x = x + vx
        y = y + vy

        if self:is_valid(x, y) then
            obj = self:get_cell(x, y)
        end
    end

    return obj
end

--[[
-- Will return a table of 8 elements, with each element
-- representing one of the 8 neighbors for the given
-- x,y cell. Each element of the returned table will consist
-- of the x,y cell pair, plus the data stored there, suitable
-- for use of the populate() method. If the neighbor cell is 
-- outside the grid, then {nil, nil, GRID_OUTSIDE} is used for 
-- that value.
-- If the given x,y values are not sane, an empty table
-- is returned instead.
--]]
function Grid:get_neighbors(x, y)
    local data = {}
    local gx, gy, vx, vy

    if not self:is_valid(x, y) then return data end

    --[[
    -- The vectors used are x,y pairs between -1 and +1
    -- for the given x,y cell. 
    -- IE: 
    --     (-1, -1) (0, -1) (1, -1)
    --     (-1,  0) (0,  0) (1,  0)
    --     (-1,  1) (0,  1) (1,  1)
    -- Value of 0,0 is ignored, since that is the cell
    -- we are working with! :D
    --]]
    for gx = -1, 1 do
        for gy = -1, 1 do
            vx = x + gx
            vy = y + gy

            if gx == 0 and gy == 0 then
                -- Do nothing
            elseif self:is_valid(vx, vy) then
                table.insert(data, {vx, vy, self:get_cell(vx, vy)})
            end
        end
    end

    return data
end

--[[
-- This method will change the grid size. If the new size is
-- smaller than the old size, data in the cells now 'outside'
-- the grid is lost. If the grid is now larger, new cells are
-- filled with the default value given when the grid was first
-- created.
--]]
function Grid:resize(newx, newy)
    if (type(newx) ~= "number" or newx == nil) or (type(newy) ~= "number" or newy == nil) then
        return false
    end

    local c, x, y

    -- Save old data.
    c = self:get_contents()

    -- Destroy/reset the internal grid.
    self._grid = {}

    for x = 1, newx do
        self._grid[x] = {}

        for y = 1, newy do
            table.insert(self._grid[x], self.default_value)
        end
    end

    -- Set the new sizes.
    self.size_x = newx
    self.size_y = newy

    -- Restore the contents.
    self:populate(c)

    return true
end

--[[
-- This method returns a table of all values in a given
-- row 'x' value.
--]]
function Grid:get_row(y)
    local row = {}

    if type(y) == "number" and 0 < y and y <= self.size_y then
        for x = 1, self.size_x do
            table.insert(row, self:get_cell(x, y))
        end
    end

    return row
end

--[[
-- This method returns a table of all values in a given
-- column 'y' value.
--]]
function Grid:get_column(x)
    local col = {}

    if type(x) == "number" and  0 < x and x <= self.size_x then
        for y = 1, self.size_y do
            table.insert(col, self:get_cell(x, y))
        end
    end

    return col
end

--[[
-- This method traverses a line of cells, from a given x,y 
-- going in 'vector' direction. The vector arg is one of the
-- GRID_* traversal constants. This will return a table of 
-- data of the cells along the traversal path or nil if 
-- the original x,y is not valid or if the vector is not one
-- of the constant values.
-- In the returned table, each element will be in the format 
-- of {x, y, obj}, suitable for populate().
--]]
function Grid:traverse(x, y, vector)
    local data = {}
    local gx, gy, vx, vy

    if self:is_valid(x, y) then
        vx, vy = table.unpack(vector)

        if vx == nil then
            -- table is still empty.
            return data
        end

        gx = x + vx
        gy = y + vy

        while self:is_valid(gx, gy) do
            local obj = self:get_cell(gx, gy)

            table.insert(data, {gx, gy, obj})

            gx = gx + vx
            gy = gy + vy
        end

        return data
    end

    return nil
end

return setmetatable(Grid, {__call = Grid.new})
