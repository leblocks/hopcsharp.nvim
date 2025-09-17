local lua_utils = require('hopcsharp.utils')
local utils = require('hopcsharp.hierarchy.utils')
local buffer = require('hopcsharp.hierarchy.buffer')

local M = {}

M.__get_type_hierarchy = function()
    local cword = vim.fn.expand('<cword>')
    local type_parameter = ''

    local node = vim.treesitter.get_node()
    if node ~= nil then
        local sibling = node:next_sibling()
        if sibling ~= nil and (sibling:type() == 'type_parameter_list' or sibling:type() == 'type_argument_list') then
            type_parameter = lua_utils.__trim_spaces(vim.treesitter.get_node_text(sibling, 0))
        end
    end

    cword = cword .. type_parameter

    local parents = utils.__get_type_parents(cword)
    local children = utils.__get_type_children(cword)

    if parents.name == children.name then
        if #parents.children == 0 and #children.children == 0 then
            -- no hierarchy to show
            return
        end
    end

    utils.__connect_parent_and_child_hierarchies(parents, children)
    buffer.__create_hierarchy_buffer(cword, parents)
end

return M
