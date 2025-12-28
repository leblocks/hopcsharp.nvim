local parse = require('hopcsharp.parse')
local database = require('hopcsharp.database')
local BufferedWriter = require('hopcsharp.database.buffer')

local M = {}

M.prepare = function(file_to_parse, file_to_open, row, column)
    M.prepare_multiple({ file_to_parse }, file_to_open, row, column)
end

M.prepare_multiple = function(files_to_parse, file_to_open, row, column)
    local writer = BufferedWriter:new(database.__get_db(), 1)
    database.__drop_db()

    for _, file_to_parse in ipairs(files_to_parse) do
        parse.__parse_file(file_to_parse, writer)
    end

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
        parse.__parse_file(file, writer)
    end
end

return M
