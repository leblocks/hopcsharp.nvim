local database = require('hopcsharp.database')

local M = {}

local function open_buffer(path)
    local full_path = vim.fs.joinpath(vim.fn.getcwd(), path)

    -- get the list of all buffers
    local buffers = vim.api.nvim_list_bufs()

    -- check if the file is already open in any buffer
    for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) == full_path then
            -- if the buffer is already open, focus it
            vim.api.nvim_set_current_buf(buf)
            return
        end
    end

    vim.api.nvim_command('edit ' .. full_path)
end

local function go_to(path, row, column)
    open_buffer(path)
    vim.fn.setcursorcharpos(row, column + 1)
end

M.__goto_definition = function()
    local db = database.__get_db()

    local rows = db:eval([[
        SELECT
            c.name AS class_name,
            n.name AS namespace_name,
            f.file_path AS path,
            c.start_row AS row,
            c.start_column AS column
        FROM classes c
        JOIN files f on f.id = c.file_path_id
        JOIN namespaces n on n.id = c.namespace_id
        WHERE c.name = :name
    ]], { name = vim.fn.expand('<cword>') })

    P(rows)

    if (#rows == 1) then
        go_to(rows[1].path, rows[1].row + 1, rows[1].column)
    end
end


return M
