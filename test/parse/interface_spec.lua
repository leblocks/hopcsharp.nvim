local parse = require('hopcsharp.parse')
local interface = require('hopcsharp.parse.interface')

local database = require('hopcsharp.database')
local query = require('hopcsharp.database.query')

describe('parse.interface', function()
    it('__parse_interfaces populates database correctly', function()
        local path = vim.fn.getcwd() .. '/test/sources/Interface1.cs'
        parse.__parse_tree(path, function(tree, file_path, file_content, db)
            database.__drop_db()

            interface.__parse_interfaces(tree:root(), file_path, file_content, db)

            local rows = db:eval(query.get_interface_by_name, { name = 'Interface1' })

            assert(#rows == 1)
            assert(rows[1].name == 'Interface1')
            assert(rows[1].namespace_name == 'This.Is.Namespace.One')
            assert(rows[1].path:match('/test/sources/Interface1.cs$'))
        end)
    end)
end)
