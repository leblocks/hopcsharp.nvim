local parse = require('hopcsharp.parse')
local record = require('hopcsharp.parse.record')

local database = require('hopcsharp.database')
local utils = require('hopcsharp.database.utils')
local query = require('hopcsharp.database.query')

describe('parse.records', function()
    it('__parse_records populates database correctly', function()
        local path = vim.fn.getcwd() .. '/test/sources/Class1.cs'
        parse.__parse_tree(path, function(tree, file_path, file_content, db)
            database.__drop_db()

            record.__parse_records(tree:root(), file_path, file_content, db)

            local rows = db:eval(query.get_object_by_name, { name = 'Record1' })

            assert(#rows == 1)
            assert(rows[1].name == 'Record1')
            assert(rows[1].namespace == 'This.Is.Namespace.One')
            assert(rows[1].path:match('/test/sources/Class1.cs$'))
            assert(rows[1].type == utils.__types.RECORD)
        end)
    end)
end)
