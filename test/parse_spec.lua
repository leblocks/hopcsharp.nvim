local parse = require('hopcsharp.parse')

describe('parse', function()
    it('__get_sorce_files returns only cs files', function()
        for _, file in pairs(parse.__get_source_files()) do
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

            -- reset db
            db:eval("delete from classes")
            db:eval("delete from namespaces")
            db:eval("delete from files")
            db:eval("vacuum")

            parse.__parse_classes(tree:root(), file_path, file_content, db)

            local rows = db:eval([[
                SELECT
                    c.name AS class_name,
                    n.name AS namespace_name,
                    f.file_path AS path,
                    c.start_row AS row,
                    c.start_column AS column
                FROM classes c
                JOIN files f on f.id = c.file_path_id
                JOIN namespaces n on n.id = c.namespace_id
                WHERE c.name = 'DummyClass'
            ]])

            assert(#rows == 1)
            assert(rows[1].class_name == 'DummyClass')
            assert(rows[1].namespace_name == 'My.Very.Own.Namespace')
            assert(rows[1].file_path ~= '')
        end)
    end)
end)

