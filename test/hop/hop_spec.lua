local hop = require('hopcsharp.hop')
local database = require('hopcsharp.database')
local databaseutils = require('hopcsharp.database.utils')
local parse = require('hopcsharp.parse')
local definition = require('hopcsharp.parse.definition')

local function prepare(file_to_parse, file_to_open, row, column)
    local path_to_parse = file_to_parse

    database.__drop_db()
    -- parse file
    parse.__parse_tree(path_to_parse, function(tree, path_id, file_content, db)
        definition.__parse_definitions(tree:root(), path_id, file_content, db)
    end)

    -- open file and stay on a desired word for hop
    vim.api.nvim_command('edit ' .. vim.fs.joinpath(vim.fn.getcwd(), file_to_open))
    vim.treesitter.get_parser(0):parse()
    vim.api.nvim_win_set_cursor(0, { row, column })
end

describe('hop', function()
    it('__hop_to_definition calls custom callback', function()
        -- parse Class1.cs and stay on a word Class1 in a file Class2.cs
        prepare('test/sources/Class1.cs', 'test/sources/Class2.cs', 10, 15)

        local called = false

        hop.__hop_to_definition(function(rows)
            called = true
            assert(#rows == 2)
            assert(rows[1].name == 'Class1')
            assert(rows[2].name == 'Class1')
        end)

        assert(called)
    end)

    it('__hop_to_definition finds attribute definition correctly', function()
        -- parse Class1.cs and stay on a word Attributed1 in a file Class2.cs
        prepare('test/sources/Class1.cs', 'test/sources/Class2.cs', 4, 11)

        local called = false

        hop.__hop_to_definition(function(rows)
            called = true
            assert(#rows == 1)
            assert(rows[1].name == 'Attributed1Attribute')
        end)

        assert(called)
    end)

    it('__hop_to_definition hops to enum definition correctly', function()
        -- parse Class1.cs and stay on a word Enum1 in a file Class2.cs
        prepare('test/sources/Class1.cs', 'test/sources/Class2.cs', 13, 14)

        hop.__hop_to_definition()

        local buf = vim.api.nvim_get_current_buf()
        local name = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))

        assert(name:find('test/sources/Class1.cs$') ~= nil)
        local position = vim.fn.getcursorcharpos(0)
        assert(position[2] == 18)
        assert(position[3] == 13)
    end)

    it('__hop_to_definition will not hop to current definition', function()
        -- parse Class1.cs and stay on a word Class1 in a file Class2.cs
        prepare('test/sources/Class1.cs', 'test/sources/Class1.cs', 5, 17)

        local called = false

        hop.__hop_to_definition(function(definitions)
            assert(#definitions == 1)
            assert(definitions[1].name == 'Class1')
            assert(definitions[1].type == databaseutils.__types.CONSTRUCTOR)
            called = true
        end)

        assert(called)
    end)
end)
