local utils = require('hopcsharp.utils')

local M = {}

local stop_callback = nil

M.__open_buffer = function(path, exists_callback, not_exists_callback)
    local buffers = vim.api.nvim_list_bufs()
    -- check if the file is already open in any buffer
    for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) == path then
            -- if the buffer is already open - do an action
            exists_callback(buf)
            return
        end
    end

    not_exists_callback(path)
end

M.__hop = function(path, row, column)
    M.__open_buffer(path, function(buf)
        vim.api.nvim_set_current_buf(buf)
    end, function(p)
        vim.api.nvim_command('edit ' .. path)
    end)

    vim.fn.setcursorcharpos(row, column + 1)
end

M.__vhop = function(path, row, column)
    M.__open_buffer(path, function(buf)
        vim.api.nvim_command('vertical sbuffer ' .. buf)
    end, function(p)
        vim.api.nvim_command('vnew ' .. path)
    end)

    vim.fn.setcursorcharpos(row, column + 1)
end

M.__shop = function(path, row, column)
    M.__open_buffer(path, function(buf)
        vim.api.nvim_command('sbuffer ' .. buf)
    end, function(p)
        vim.api.nvim_command('split ' .. path)
    end)

    vim.fn.setcursorcharpos(row, column + 1)
end

M.__thop = function(path, row, column)
    M.__open_buffer(path, function(buf)
        vim.api.nvim_command('tab sbuffer ' .. buf)
    end, function(p)
        vim.api.nvim_command('tabnew ' .. path)
    end)

    vim.fn.setcursorcharpos(row, column + 1)
end

M.__populate_quickfix = function(entries, jump_on_quickfix, type_converter)
    -- stop previous quickfix population
    -- won't work 100% but it much better
    -- rathen that nothing
    if stop_callback then
        stop_callback()
        stop_callback = nil
    end

    -- remove previous quickfix entries
    vim.fn.setqflist({}, 'r')

    utils.__scheduled_iteration(entries, function(i, item, _, stop)
        if i == 1 then
            stop_callback = stop
        end

        vim.fn.setqflist({
            {
                filename = item.path,
                lnum = item.row + 1,
                col = item.col,
                text = string.format('%-15s | %s', type_converter(item.type), item.namespace or ''),
            },
        }, 'a')
    end)

    vim.cmd([[ :copen ]])

    if jump_on_quickfix then
        vim.cmd([[ :cc! ]])
    end
end

return M
