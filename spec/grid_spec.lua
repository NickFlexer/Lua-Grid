---
-- grid_spec.lua


describe("Grid", function ()

    require "grid"

    describe("Initialize", function ()
        it("with gefault size", function ()
            local g = grid.Grid()
            assert.are.table(g)
            assert.are.equal(g.size_x, 4)
            assert.are.equal(g.size_y, 4)
        end)

        it("with custom size", function ()
            local g = grid.Grid(10, 1)
            assert.are.table(g)
            assert.are.equal(g.size_x, 10)
            assert.are.equal(g.size_y, 1)
        end)

        it("with default data", function ()
            local g = grid.Grid(10, 10)
            assert.are.equal(g:get_cell(2, 2), grid.GRID_NIL_VALUE)
            assert.are.equal(g.def_value, grid.GRID_NIL_VALUE)
        end)

        it("with custom data", function ()
            local g = grid.Grid(10, 10, "some")
            assert.are.equal(g:get_cell(2, 2), "some")
            assert.are.equal(g.def_value, "some")
        end)
    end)

    describe("Cell validation", function ()
        local test_grid

        setup(function()
            test_grid = grid.Grid(30, 10)
        end)

        teardown(function()
            test_grid = nil
        end)

        it("valid cells", function ()
            assert.is.True(test_grid:is_valid(1, 1))
            assert.is.True(test_grid:is_valid(1, 10))
            assert.is.True(test_grid:is_valid(30, 10))
            assert.is.True(test_grid:is_valid(30, 1))
        end)

        it("not valid cells", function ()
            assert.is.False(test_grid:is_valid(0, 0))
            assert.is.False(test_grid:is_valid(30, 11))
            assert.is.False(test_grid:is_valid(31, 10))
        end)

        it("error parameters", function ()
            assert.is.False(test_grid:is_valid())
            assert.is.False(test_grid:is_valid("a", "b"))
        end)
    end)

    describe("Get cell", function ()
        local test_grid

        setup(function()
            test_grid = grid.Grid(30, 10, "T")
        end)

        teardown(function()
            test_grid = nil
        end)

        it("get valid cell", function ()
            local data = test_grid:get_cell(6, 8)
            assert.are.equal(data, "T")
        end)

        it("get invalid cell", function ()
            local data = test_grid:get_cell("a", "b")
            assert.is.Nil(data)
        end)
    end)

    describe("Get cells", function ()
        local test_grid

        setup(function()
            test_grid = grid.Grid(30, 10, "T")
        end)

        teardown(function()
            test_grid = nil
        end)

        it("valid cells table", function ()
            local cells_table = {
                {1, 1},
                {20, 6}
            }

            local data_table = test_grid:get_cells(cells_table)
            assert.is.Table(data_table)
        end)
    end)

    describe("Set cell", function ()
        local test_grid

        setup(function()
            test_grid = grid.Grid(30, 10, "T")
        end)

        teardown(function()
            test_grid = nil
        end)

        it("set data in cell", function ()
            test_grid:set_cell(11, 9, "NEW")
            assert.are.equal(test_grid:get_cell(11, 9), "NEW")
        end)
    end)

    describe("Reset cell", function ()
        it("valid cell to default value", function ()
            local g = grid.Grid(10, 5)
            g:set_cell(2, 3, "DATA")
            local res = g:reset_cell(2, 3)
            assert.is.True(res)
            assert.are.equal(g:get_cell(2, 3), grid.GRID_NIL_VALUE)
        end)

        it("valid cell to custom value", function ()
            local g = grid.Grid(10, 5, "T")
            g:set_cell(2, 3, "DATA")
            local res = g:reset_cell(2, 3)
            assert.is.True(res)
            assert.are.equal(g:get_cell(2, 3), "T")
        end)

        it("try to reset invalid cell", function ()
            local g = grid.Grid(10, 5, "T")
            local res = g:reset_cell(100, 100)
            assert.is.False(res)
        end)
    end)

    describe("Reset all cells", function ()
        it("to default value", function ()
            local g = grid.Grid(17, 73)
            g:set_cell(11, 11, "Some")
            g:reset_all()
            assert.are.equal(g:get_cell(11, 11), grid.GRID_NIL_VALUE)
        end)

        it("to custom value", function ()
            local g = grid.Grid(8, 2, "Base")
            g:set_cell(1, 1, "Some")
            g:reset_all()
            assert.are.equal(g:get_cell(1, 1), "Base")
        end)
    end)

    describe("Populate grid", function ()
        it("with new data", function ()
            local g = grid.Grid(10, 10, "Data")
            local data = {
                {1, 1, "foo"},
                {2, 2, "bar"}
            }
            local res = g:populate(data)
            assert.is.True(res)
            assert.are.equal(g:get_cell(1, 1), "foo")
            assert.are.equal(g:get_cell(2, 2), "bar")
        end)

        it("with default data", function ()
            local g = grid.Grid(10, 10, "Data")
            g:set_cell(1, 1, "a")
            g:set_cell(1, 1, "b")
            local data = {
                {1, 1},
                {2, 2}
            }
            local res = g:populate(data)
            assert.is.True(res)
            assert.are.equal(g:get_cell(1, 1), "Data")
            assert.are.equal(g:get_cell(2, 2), "Data")
        end)

        it("data is not table", function ()
            local g = grid.Grid(10, 10, "Data")
            local res = g:populate("aaaaa")
            assert.is.False(res)
        end)
    end)
end)
