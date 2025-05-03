local parse = require('hopcsharp.parse')
local interface = require('hopcsharp.parse.interface')

local database = require('hopcsharp.database')
local query = require('hopcsharp.database.query')

describe('parse.interface', function()
    it('__parse_interfaces populates database correctly', function()
        local path = vim.fn.getcwd() .. '/test/sources/DummyInterface.cs'
        parse.__parse_tree(path, function(tree, file_path, file_content, db)
            database.__drop_db()

            interface.__parse_interfaces(tree:root(), file_path, file_content, db)

            local rows = db:eval(query.get_interface_by_name, { name = 'IDummy' })

            assert(#rows == 1)
            assert(rows[1].name == 'IDummy')
            assert(rows[1].namespace_name == 'My.Very.Own.Namespace3')
            assert(rows[1].path ~= '')
        end)
    end)
end)
