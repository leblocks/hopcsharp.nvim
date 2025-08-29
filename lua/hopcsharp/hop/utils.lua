local M = {}

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

return M
