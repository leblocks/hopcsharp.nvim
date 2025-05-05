local parse = require('hopcsharp.parse')
local enum = require('hopcsharp.parse.enum')

local database = require('hopcsharp.database')
local query = require('hopcsharp.database.query')

describe('parse.enums', function()
    it('__parse_enums populates database correctly', function()
        local path = vim.fn.getcwd() .. '/test/sources/Class1.cs'
        parse.__parse_tree(path, function(tree, file_path, file_content, db)
            database.__drop_db()

            enum.__parse_enums(tree:root(), file_path, file_content, db)

            local rows = db:eval(query.get_enum_by_name, { name = 'Enum1' })

            assert(#rows == 1)
            assert(rows[1].name == 'Enum1')
            assert(rows[1].namespace_name == 'This.Is.Namespace.One')
            assert(rows[1].path:match('/test/sources/Class1.cs$'))
            assert(rows[1].type == 'enum')
        end)
    end)
end)
