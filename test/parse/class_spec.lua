local parse = require('hopcsharp.parse')
local class = require('hopcsharp.parse.class')

local database = require('hopcsharp.database')
local query = require('hopcsharp.database.query')

describe('parse.class', function()
    it('__parse_classes populates database correctly', function()
        local path = vim.fn.getcwd() .. '/test/sources/DummyClass1.cs'
        parse.__parse_tree(path, function(tree, file_path, file_content, db)
            database.__drop_db()

            class.__parse_classes(tree:root(), file_path, file_content, db)

            local rows = db:eval(query.get_class_by_name, { name = 'DummyClass' })

            assert(#rows == 1)
            assert(rows[1].name == 'DummyClass')
            assert(rows[1].namespace_name == 'My.Very.Own.Namespace')
            assert(rows[1].path ~= '')
        end)
    end)
end)
