
local M = {}

M.__open_buffer = function(path)
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

M.__hop = function(path, row, column)
    M.__open_buffer(path)
    vim.fn.setcursorcharpos(row, column + 1)
end

M.__format_entry = function(type, path)
    return string.format("%-15s %s", type, vim.fn.pathshorten(path, 5))
end

return M
