local parse = require('hopcsharp.parse')
local query = require('hopcsharp.query')
local database = require('hopcsharp.database')

describe('parse', function()
    it('__get_sorce_files returns only cs files', function()
        local files = parse.__get_source_files()
        assert(#files == 3)
        for _, file in pairs(files) do
            assert(file:find('.cs$') ~= nil)
        end
    end)

    it('__parse_tree parses file tree', function()
        local path = vim.fn.getcwd() .. '/test/sources/DummyClass1.cs'
        parse.__parse_tree(path, function(tree, file_path, file_content, db)
            assert(tree ~= nil)
            assert(file_content ~= nil)
            assert(file_path == path)
            assert(db ~= nil)
        end)
    end)

    it('__parse_classes populates database correctly', function()
        local path = vim.fn.getcwd() .. '/test/sources/DummyClass1.cs'
        parse.__parse_tree(path, function(tree, file_path, file_content, db)

            database.__drop_db()

            parse.__parse_classes(tree:root(), file_path, file_content, db)

            local rows = db:eval(query.get_class_by_name, { name = 'DummyClass' })

            assert(#rows == 1)
            assert(rows[1].name == 'DummyClass')
            assert(rows[1].namespace_name == 'My.Very.Own.Namespace')
            assert(rows[1].path ~= '')
        end)
    end)


    it('__parse_parse_interfaces populates database correctly', function()
        local path = vim.fn.getcwd() .. '/test/sources/DummyInterface.cs'
        parse.__parse_tree(path, function(tree, file_path, file_content, db)

            database.__drop_db()

            parse.__parse_interfaces(tree:root(), file_path, file_content, db)

            local rows = db:eval(query.get_interface_by_name, { name = 'IDummy' })

            assert(#rows == 1)
            assert(rows[1].name == 'IDummy')
            assert(rows[1].namespace_name == 'My.Very.Own.Namespace3')
            assert(rows[1].path ~= '')
        end)
    end)

end)

