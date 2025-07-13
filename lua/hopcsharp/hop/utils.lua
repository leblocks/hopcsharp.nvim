local M = {}

M.__open_buffer = function(path, open_command)
    open_command = open_command or 'edit'

    -- paths in db are stored relatively to working dir
    -- get the list of all buffers
    local buffers = vim.api.nvim_list_bufs()

    -- check if the file is already open in any buffer
    for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) == path then
            -- if the buffer is already open, focus it
            vim.api.nvim_set_current_buf(buf)
            return
        end
    end

    vim.api.nvim_command(open_command .. ' ' .. path)
end

M.__hop = function(path, row, column, open_command)
    M.__open_buffer(path, open_command or 'edit')
    vim.fn.setcursorcharpos(row, column + 1)
end

return M
