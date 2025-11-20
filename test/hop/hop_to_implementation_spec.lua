local hop = require('hopcsharp.hop')
local databaseutils = require('hopcsharp.database.utils')
local utils = require('test.utils')

describe('hop_to_implementation', function()
    it('__hop_to_implementation hops correctly', function()
        -- parse Class1.cs and stay on a word Interface2 in a file Interface2.cs
        utils.prepare('test/sources/Class1.cs', 'test/sources/Interface2.cs', 4, 18)

        hop.__hop_to_implementation()

        local buf = vim.api.nvim_get_current_buf()
        local name = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))

        assert(name:find('test/sources/Class1.cs$') ~= nil)
        local position = vim.fn.getcursorcharpos(0)
        assert(position[2] == 5)
        assert(position[3] == 14)
    end)

    it('__hop_to_implementation hops from interface method definition to implementation class definition', function()
        -- parse hop_to_definition.cs and stay on a function call Foo in a file hop_to_definition.cs
        utils.prepare('test/sources/hop_to_implementation.cs', 'test/sources/hop_to_implementation.cs', 15, 26)

        local called = false
        hop.__hop_to_implementation({
            callback = function(implementations)
                called = true
                assert(#implementations == 1)
                assert(implementations[1].name == 'GetString')
                assert(implementations[1].row == 4)
                assert(implementations[1].column == 18)
                assert(implementations[1].type == databaseutils.types.METHOD)
            end,
        })

        assert(called)
    end)

    it('__hop_to_implementation hops from class method definition to implementation class definition', function()
        -- parse hop_to_definition.cs and stay on a function call Foo in a file hop_to_definition.cs
        utils.prepare('test/sources/hop_to_implementation.cs', 'test/sources/hop_to_implementation.cs', 19, 27)

        local called = false
        hop.__hop_to_implementation({
            callback = function(implementations)
                called = true
                assert(#implementations == 1)
                assert(implementations[1].name == 'DoSomething')
                assert(implementations[1].row == 8)
                assert(implementations[1].column == 16)
                assert(implementations[1].type == databaseutils.types.METHOD)
            end,
        })

        assert(called)
    end)

    it('__hop_to_implementation hops to nested generic class definition correctly', function()
        utils.prepare('test/sources/get_type_hierarchy.cs', 'test/sources/get_type_hierarchy.cs', 39, 12)

        local called = false
        hop.__hop_to_implementation({
            callback = function(implementations)
                called = true
                assert(#implementations == 1)
                assert(implementations[1].name == 'Bark<T>')
                assert(implementations[1].row == 42)
                assert(implementations[1].column == 10)
                assert(implementations[1].type == databaseutils.types.CLASS)
            end,
        })

        assert(called)
    end)
end)
