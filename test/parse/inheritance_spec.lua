local database = require('hopcsharp.database')

local parse = require('hopcsharp.parse')
local inheritance = require('hopcsharp.parse.inheritance')


describe('parse.inheritance', function()
    it('__parse_inheritance populates database correctly', function()
        database.__drop_db()
        local path = vim.fn.getcwd() .. '/test/sources/Class1.cs'

        parse.__parse_tree(path, function(tree, path_id, file_content, db)
            inheritance.__parse_inheritance(tree:root(), path_id, file_content, db)

            local rows = db:eval([[select * from inheritance i where i.base = :name ]], { name = 'Interface1' })
            assert(#rows == 1)
            assert(rows[1].name == 'Class1')

            rows = db:eval([[select * from inheritance i where i.base = :name ]], { name = 'Attribute' })
            assert(#rows == 1)
            assert(rows[1].name == 'Attributed1Attribute')
        end)
    end)
end)
