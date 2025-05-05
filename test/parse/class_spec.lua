local parse = require('hopcsharp.parse')
local class = require('hopcsharp.parse.class')

local database = require('hopcsharp.database')
local query = require('hopcsharp.database.query')

describe('parse.class', function()
    it('__parse_classes populates database correctly', function()
        local path = vim.fn.getcwd() .. '/test/sources/Class1.cs'
        parse.__parse_tree(path, function(tree, file_path, file_content, db)
            database.__drop_db()

            class.__parse_classes(tree:root(), file_path, file_content, db)

            local rows = db:eval(query.get_class_by_name, { name = 'Class1' })

            assert(#rows == 1)
            assert(rows[1].name == 'Class1')
            assert(rows[1].namespace_name == 'This.Is.Namespace.One')
            assert(rows[1].path:match('test/sources/Class1.cs$'))
            assert(rows[1].type == 'class')
        end)
    end)
end)
