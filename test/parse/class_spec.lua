local parse = require('hopcsharp.parse')
local class = require('hopcsharp.parse.class')

local database = require('hopcsharp.database')
local utils = require('hopcsharp.database.utils')
local query = require('hopcsharp.database.query')

describe('parse.class', function()
    it('__parse_classes populates database correctly', function()
        local path = vim.fn.getcwd() .. '/test/sources/Class1.cs'
        parse.__parse_tree(path, function(tree, file_path, file_content, db)
            database.__drop_db()

            class.__parse_classes(tree:root(), file_path, file_content, db)

            local rows = db:eval(query.get_object_by_name, { name = 'Class1' })

            -- classes table is populated correctly
            assert(#rows == 1)
            assert(rows[1].name == 'Class1')
            assert(rows[1].namespace == 'This.Is.Namespace.One')
            assert(rows[1].path:match('test/sources/Class1.cs$'))
            assert(rows[1].type == utils.__types.CLASS)

            local class_id = rows[1].id

            -- class_methods table is populated correctly
            rows = db:eval(query.get_method_by_name, { name = 'Foo' })
            assert(#rows == 1)
            assert(rows[1].name == 'Foo')
            assert(rows[1].namespace == 'This.Is.Namespace.One')
            assert(rows[1].path:match('test/sources/Class1.cs$'))
            assert(rows[1].type == utils.__types.METHOD)
            assert(rows[1].parent_id == class_id)

            -- class_methods table is populated correctly
            rows = db:eval(query.get_method_by_name, { name = 'Bar' })
            assert(#rows == 1)
            assert(rows[1].name == 'Bar')
            assert(rows[1].namespace == 'This.Is.Namespace.One')
            assert(rows[1].path:match('test/sources/Class1.cs$'))
            assert(rows[1].type == utils.__types.METHOD)
            assert(rows[1].parent_id == class_id)
        end)
    end)
end)
