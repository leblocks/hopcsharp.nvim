local database = require('hopcsharp.database')
local BufferedWriter = require('hopcsharp.database.buffer')

local parse = require('hopcsharp.parse')
local using = require('hopcsharp.parse.using')

describe('parse.using', function()
    it('__parse_usings populates database correctly', function()
        database.__drop_db()
        local path = vim.fn.getcwd() .. '/test/sources/usings/FirstExample.cs'
        local writer = BufferedWriter:new(database.__get_db(), 1)
        local db = database.__get_db()

        parse.__parse_tree(path, function(tree, path_id, file_content, wr)
            using.__parse_usings(tree:root(), path_id, file_content, wr)
            local rows = db:eval([[ select * from usings where namespace == 'System' ]])
            assert(#rows == 1)
            assert(rows[1].path_id > 0)
            assert(rows[1].namespace == 'System')

            rows = db:eval([[ select * from usings where namespace == 'System.Collections' ]])
            assert(#rows == 1)
            assert(rows[1].path_id > 0)
            assert(rows[1].namespace == 'System.Collections')
        end, writer)
    end)

    it('__parse_usings populates database correctly - usings inside namespace', function()
        database.__drop_db()
        local path = vim.fn.getcwd() .. '/test/sources/usings/SecondExample.cs'
        local writer = BufferedWriter:new(database.__get_db(), 1)
        local db = database.__get_db()

        parse.__parse_tree(path, function(tree, path_id, file_content, wr)
            using.__parse_usings(tree:root(), path_id, file_content, wr)
            local rows = db:eval([[ select * from usings where namespace == 'System' ]])
            assert(#rows == 1)
            assert(rows[1].path_id > 0)
            assert(rows[1].namespace == 'System')

            rows = db:eval([[ select * from usings where namespace == 'System.Collections' ]])
            assert(#rows == 1)
            assert(rows[1].path_id > 0)
            assert(rows[1].namespace == 'System.Collections')
        end, writer)
    end)
end)
