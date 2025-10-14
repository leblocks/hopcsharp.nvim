local database = require('hopcsharp.database')
local BufferedWriter = require('hopcsharp.database.buffer')

local parse = require('hopcsharp.parse')
local inheritance = require('hopcsharp.parse.inheritance')

describe('parse.inheritance', function()
    it('__parse_inheritance populates database correctly', function()
        database.__drop_db()
        local path = vim.fn.getcwd() .. '/test/sources/Class1.cs'
        local writer = BufferedWriter:new(database.__get_db(), 1)
        local db = database.__get_db()

        parse.__parse_tree(path, function(tree, path_id, file_content, wr)
            inheritance.__parse_inheritance(tree:root(), path_id, file_content, wr)

            local rows = db:eval([[select * from inheritance i where i.base = :name ]], { name = 'Interface1' })
            assert(#rows == 1)
            assert(rows[1].name == 'Class1')
            assert(rows[1].path_id ~= nil)

            rows = db:eval([[select * from inheritance i where i.base = :name ]], { name = 'Attribute' })
            assert(#rows == 1)
            assert(rows[1].name == 'Attributed1Attribute')
            assert(rows[1].path_id ~= nil)
        end, writer)
    end)
end)
