local parse = require('hopcsharp.parse')
local struct = require('hopcsharp.parse.struct')

local database = require('hopcsharp.database')
local query = require('hopcsharp.database.query')

describe('parse.structs', function()
    it('__parse_structs populates database correctly', function()
        local path = vim.fn.getcwd() .. '/test/sources/Class1.cs'
        parse.__parse_tree(path, function(tree, file_path, file_content, db)
            database.__drop_db()

            struct.__parse_structs(tree:root(), file_path, file_content, db)

            local rows = db:eval(query.get_struct_by_name, { name = 'Struct1' })

            assert(#rows == 1)
            assert(rows[1].name == 'Struct1')
            assert(rows[1].namespace_name == 'This.Is.Namespace.One')
            assert(rows[1].path:match('/test/sources/Class1.cs$'))
            assert(rows[1].type == 'struct')
        end)
    end)
end)
