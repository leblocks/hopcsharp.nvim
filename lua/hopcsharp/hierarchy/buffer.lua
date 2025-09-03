local utils = require('hopcsharp.hop.utils')

local M = {}

local prefix = '   '

-- TODO move to tree utils
local function tree_to_buffer_lines(node, lines, level)
    if node == nil then
        return
    end

    table.insert(lines, string.rep(prefix, level, '') .. node.name)

    if node.children ~= nil then
        for _, child in ipairs(node.children) do
            tree_to_buffer_lines(child, lines, level + 1)
        end
    end
end

M.__get_hierarchy_buffer_name = function(type_name)
    return 'hopcsharp://hierarchy/' .. type_name
end

M.__create_hierarchy_buffer = function(type_name, tree_root)
    local buffer_name = M.__get_hierarchy_buffer_name(type_name)
    local buffer_lines = {
        'Use hop_to_defintion and hop_to_implementation here to navigate further',
        '',
    }

    local not_exists = function(path)
        local buf = vim.api.nvim_create_buf(true, true)

        -- populate hierarchy buffer content
        tree_to_buffer_lines(tree_root, buffer_lines, 0)

        vim.api.nvim_create_autocmd('BufWinEnter', {
            callback = function()
                vim.fn.matchadd('@type', type_name)
            end,
            buffer = buf,
        })

        vim.api.nvim_create_autocmd('BufWinLeave', {
            callback = function()
                vim.fn.clearmatches()
            end,
            buffer = buf,
        })

        vim.api.nvim_buf_set_name(buf, path)
        vim.api.nvim_buf_set_lines(buf, 0, -1, true, buffer_lines)
        vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
        vim.api.nvim_set_current_buf(buf)
    end

    utils.__open_buffer(buffer_name, vim.api.nvim_set_current_buf, not_exists)
end

return M
