local hop = require('hopcsharp.hop')
local database = require('hopcsharp.database')
local databaseutils = require('hopcsharp.database.utils')
local parse = require('hopcsharp.parse')
local definition = require('hopcsharp.parse.definition')
local inheritance = require('hopcsharp.parse.inheritance')
local BufferedWriter = require('hopcsharp.database.buffer')

local function prepare(file_to_parse, file_to_open, row, column)
    local path_to_parse = file_to_parse
    local writer = BufferedWriter:new(database.__get_db(), 1)

    database.__drop_db()
    -- parse file
    parse.__parse_tree(path_to_parse, function(tree, path_id, file_content, wr)
        definition.__parse_definitions(tree:root(), path_id, file_content, wr)
        inheritance.__parse_inheritance(tree:root(), path_id, file_content, wr)
    end, writer)

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
        -- parse Class1.cs and stay on a word Class1 in a file Class1.cs
        prepare('test/sources/Class1.cs', 'test/sources/Class1.cs', 5, 17)

        local called = false

        hop.__hop_to_definition(function(definitions)
            assert(#definitions == 1)
            assert(definitions[1].name == 'Class1')
            assert(definitions[1].type == databaseutils.types.CONSTRUCTOR)
            called = true
        end)

        assert(called)
    end)

    it('__hop_to_definition will not hop to current definition not other definitions', function()
        -- parse Class1.cs and stay on a word Enum1 in a file Class1.cs
        prepare('test/sources/Class1.cs', 'test/sources/Class1.cs', 18, 13)

        local called = false

        hop.__hop_to_definition(function(_)
            called = true
        end)

        assert(called == false)
    end)

    it('__hop_to_implementation hops correctly', function()
        -- parse Class1.cs and stay on a word Interface2 in a file Interface2.cs
        prepare('test/sources/Class1.cs', 'test/sources/Interface2.cs', 4, 18)

        hop.__hop_to_implementation()

        local buf = vim.api.nvim_get_current_buf()
        local name = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))

        assert(name:find('test/sources/Class1.cs$') ~= nil)
        local position = vim.fn.getcursorcharpos(0)
        assert(position[2] == 5)
        assert(position[3] == 14)
    end)

    it('__hop_to_definition hops to method definition correctly', function()
        -- parse hop_to_definition.cs and stay on a function call Foo in a file hop_to_definition.cs
        prepare('test/sources/hop_to_definition.cs', 'test/sources/hop_to_definition.cs', 11, 9)

        local called = false
        hop.__hop_to_definition(function(definitions)
            called = true
            assert(#definitions == 1)
            assert(definitions[1].name == 'Foo')
            assert(definitions[1].row == 7)
            assert(definitions[1].column == 16)
            assert(definitions[1].type == databaseutils.types.METHOD)
        end)

        assert(called)
    end)

    it('__hop_to_implementation hops from interface method definition to implementation class definition', function()
        -- parse hop_to_definition.cs and stay on a function call Foo in a file hop_to_definition.cs
        prepare('test/sources/hop_to_implementation.cs', 'test/sources/hop_to_implementation.cs', 15, 26)

        local called = false
        hop.__hop_to_implementation(function(implementations)
            called = true
            assert(#implementations == 1)
            assert(implementations[1].name == 'GetString')
            assert(implementations[1].row == 4)
            assert(implementations[1].column == 18)
            assert(implementations[1].type == databaseutils.types.METHOD)
        end)

        assert(called)
    end)

    it('__hop_to_implementation hops from class method definition to implementation class definition', function()
        -- parse hop_to_definition.cs and stay on a function call Foo in a file hop_to_definition.cs
        prepare('test/sources/hop_to_implementation.cs', 'test/sources/hop_to_implementation.cs', 19, 27)

        local called = false
        hop.__hop_to_implementation(function(implementations)
            called = true
            assert(#implementations == 1)
            assert(implementations[1].name == 'DoSomething')
            assert(implementations[1].row == 8)
            assert(implementations[1].column == 16)
            assert(implementations[1].type == databaseutils.types.METHOD)
        end)

        assert(called)
    end)

    it('__get_type_parents parses tree from type to parent type correctly - from a leaf', function()
        prepare('test/sources/get_type_hierarchy.cs', 'test/sources/get_type_hierarchy.cs', 1, 1)

        local root = hop.__get_type_parents('Class1Generation4')

        assert(root ~= nil)
        assert(root.name == 'Class1Generation1')
        assert(#root.children == 1)

        assert(root.children[1].name == 'Class1Generation2')
        assert(#root.children[1].children == 1)

        assert(root.children[1].children[1].name == 'Class1Generation3')
        assert(#root.children[1].children[1].children == 1)

        assert(root.children[1].children[1].children[1].name == 'Class1Generation4')
        assert(#root.children[1].children[1].children[1].children == 0)
    end)

    it('__get_type_parents parses tree from type to parent type correctly - from a middle node', function()
        prepare('test/sources/get_type_hierarchy.cs', 'test/sources/get_type_hierarchy.cs', 1, 1)

        local root = hop.__get_type_parents('Class1Generation3')

        assert(root ~= nil)
        assert(root.name == 'Class1Generation1')
        assert(#root.children == 1)

        assert(root.children[1].name == 'Class1Generation2')
        assert(#root.children[1].children == 1)

        assert(root.children[1].children[1].name == 'Class1Generation3')
        assert(#root.children[1].children[1].children == 0)
    end)

    it('__get_type_parents parses tree from type to parent type correctly - from root node', function()
        prepare('test/sources/get_type_hierarchy.cs', 'test/sources/get_type_hierarchy.cs', 1, 1)

        local root = hop.__get_type_parents('Class1Generation1')

        assert(root ~= nil)
        assert(root.name == 'Class1Generation1')
        assert(#root.children == 0)
    end)
end)
