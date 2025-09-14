local utils = require('hopcsharp.hop.utils')
local tree = require('hopcsharp.hierarchy.tree')

local M = {}

local prefix = '   '

M.__get_hierarchy_buffer_name = function(type_name)
    return 'hopcsharp://hierarchy/' .. type_name
end

M.__create_hierarchy_buffer = function(type_name, tree_root)
    local buffer_name = M.__get_hierarchy_buffer_name(type_name)
    local leaf_nodes = tree.__get_leaf_nodes(tree_root)

    local not_exists = function(path)
        local buf = vim.api.nvim_create_buf(true, true)

        local buffer_lines = tree.__tree_to_lines(tree_root, prefix) or {}
        table.insert(buffer_lines, 1, '')
        table.insert(buffer_lines, 1, 'Use hop_to_defintion and hop_to_implementation here to navigate further')
        table.insert(buffer_lines, 1, 'Hierarchy for ' .. type_name)

        vim.api.nvim_create_autocmd('BufWinEnter', {
            callback = function()
                vim.fn.matchadd('@lsp.type.enum', type_name)
                for _, leaf_node in ipairs(leaf_nodes) do
                    vim.fn.matchadd('@lsp.type.enumMember', leaf_node)
                end
            end,
            buffer = buf,
        })

        -- clear all highlights when leaving buffer
        -- so code won't get unexpected highlights
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
