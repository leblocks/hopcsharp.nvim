local hop = require('hopcsharp.hop')
local databaseutils = require('hopcsharp.database.utils')
local utils = require('test.utils')

describe('hop_to_definition', function()
    it('__hop_to_definition calls custom callback', function()
        -- parse Class1.cs and stay on a word Class1 in a file Class2.cs
        utils.prepare('test/sources/Class1.cs', 'test/sources/Class2.cs', 10, 15)

        local called = false

        hop.__hop_to_definition({
            callback = function(rows)
                called = true
                assert(#rows == 2)
                assert(rows[1].name == 'Class1')
                assert(rows[2].name == 'Class1')
            end,
        })

        assert(called)
    end)

    it('__hop_to_definition finds attribute definition correctly', function()
        -- parse Class1.cs and stay on a word Attributed1 in a file Class2.cs
        utils.prepare('test/sources/Class1.cs', 'test/sources/Class2.cs', 4, 11)

        local called = false

        hop.__hop_to_definition({
            callback = function(rows)
                called = true
                assert(#rows == 1)
                assert(rows[1].name == 'Attributed1Attribute')
            end,
        })

        assert(called)
    end)

    it('__hop_to_definition hops to enum definition correctly', function()
        -- parse Class1.cs and stay on a word Enum1 in a file Class2.cs
        utils.prepare('test/sources/Class1.cs', 'test/sources/Class2.cs', 13, 14)

        hop.__hop_to_definition()

        local buf = vim.api.nvim_get_current_buf()
        local name = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))

        assert(name:find('test/sources/Class1.cs$') ~= nil)
        local position = vim.fn.getcursorcharpos(0)
        assert(position[2] == 18)
        assert(position[3] == 13)
    end)

    it('__hop_to_definition will not hop to current definition', function()
        -- parse Class1.cs and stay on a word Class1 in a file Class1.cs
        utils.prepare('test/sources/Class1.cs', 'test/sources/Class1.cs', 5, 17)

        local called = false

        hop.__hop_to_definition({
            callback = function(definitions)
                assert(#definitions == 1)
                assert(definitions[1].name == 'Class1')
                assert(definitions[1].type == databaseutils.types.CONSTRUCTOR)
                called = true
            end,
        })

        assert(called)
    end)

    it('__hop_to_definition will not hop to current definition not other definitions', function()
        -- parse Class1.cs and stay on a word Enum1 in a file Class1.cs
        utils.prepare('test/sources/Class1.cs', 'test/sources/Class1.cs', 18, 13)

        local called = false

        hop.__hop_to_definition({
            callback = function(_)
                called = true
            end,
        })

        assert(called == false)
    end)

    it('__hop_to_definition hops to method definition correctly', function()
        -- parse hop_to_definition.cs and stay on a function call Foo in a file hop_to_definition.cs
        utils.prepare('test/sources/hop_to_definition.cs', 'test/sources/hop_to_definition.cs', 11, 9)

        local called = false
        hop.__hop_to_definition({
            callback = function(definitions)
                called = true
                assert(#definitions == 1)
                assert(definitions[1].name == 'Foo')
                assert(definitions[1].row == 7)
                assert(definitions[1].column == 16)
                assert(definitions[1].type == databaseutils.types.METHOD)
            end,
        })

        assert(called)
    end)
end)
