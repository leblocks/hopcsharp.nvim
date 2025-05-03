local database = require('hopcsharp.database')
local query = require('hopcsharp.database.query')

local M = {}

local function open_buffer(path)
    -- paths in db are stored relatively to working dir
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

M.__goto_definition = function(callback)
    local db = database.__get_db()
    local cword = vim.fn.expand('<cword>')

    local rows = db:eval(query.get_definition_by_name, { name = cword  })

    if type(rows) ~= 'table' then
        -- query found nothing
        return
    end

    if callback ~= nil then
        callback(rows)
        return
    end

    if #rows == 1 then
        go_to(rows[1].path, rows[1].row + 1, rows[1].column)
        return
    end

    vim.ui.select(rows, {
        prompt = ' definitions >',
        format_item = function(row)
            return row.type .. '\t\t' .. row.namespace_name .. '\t\t' .. row.path
        end,
    }, function(choice)
        if choice ~= nil then
            go_to(choice.path, choice.row + 1, choice.column)
        end
    end)
end


return M
