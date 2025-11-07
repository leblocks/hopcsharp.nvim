local parse = require('hopcsharp.parse')
local database = require('hopcsharp.database')
local definition = require('hopcsharp.parse.definition')
local inheritance = require('hopcsharp.parse.inheritance')
local reference = require('hopcsharp.parse.reference')
local BufferedWriter = require('hopcsharp.database.buffer')

local M = {}

M.prepare = function(file_to_parse, file_to_open, row, column)
    local path_to_parse = file_to_parse
    local writer = BufferedWriter:new(database.__get_db(), 1)

    database.__drop_db()
    -- parse file
    parse.__parse_tree(path_to_parse, function(tree, path_id, file_content, wr)
        definition.__parse_definitions(tree:root(), path_id, file_content, wr)
        inheritance.__parse_inheritance(tree:root(), path_id, file_content, wr)
        reference.__parse_reference(tree:root(), path_id, file_content, wr)
    end, writer)

    -- open file and stay on a desired word for hop
    vim.api.nvim_command('edit ' .. vim.fs.joinpath(vim.fn.getcwd(), file_to_open))
    vim.treesitter.get_parser(0):parse()
    vim.api.nvim_win_set_cursor(0, { row, column })
end

M.init_test_database = function()
    database.__drop_db()
    local writer = BufferedWriter:new(database.__get_db(), 1)
    local files = parse.__get_source_files()

    for _, file in ipairs(files) do
        parse.__parse_tree(file, function(tree, path_id, file_content, wr)
            definition.__parse_definitions(tree:root(), path_id, file_content, wr)
            inheritance.__parse_inheritance(tree:root(), path_id, file_content, wr)
        end, writer)
    end
end

return M
