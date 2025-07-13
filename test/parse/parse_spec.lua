local parse = require('hopcsharp.parse')
local database = require('hopcsharp.database')
local BufferedWriter = require('hopcsharp.database.buffer')

describe('parse', function()
    it('__get_sorce_files returns only cs files', function()
        local files = parse.__get_source_files()
        assert(#files == 4)
        for _, file in pairs(files) do
            assert(file:find('.cs$') ~= nil)
        end
    end)

    it('__parse_tree parses file tree', function()
        database.__drop_db()
        local path = vim.fn.getcwd() .. '/test/sources/Class1.cs'
        local writer = BufferedWriter:new(database.__get_db(), 1)
        parse.__parse_tree(path, function(tree, path_id, file_content, wr)
            assert(tree ~= nil)
            assert(file_content ~= nil)
            assert(path_id == 1)
            assert(wr ~= nil)
        end, writer)
    end)
end)
