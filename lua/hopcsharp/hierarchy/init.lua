local lua_utils = require('hopcsharp.utils')
local utils = require('hopcsharp.hierarchy.utils')
local buffer = require('hopcsharp.hierarchy.buffer')

local M = {}

M.__get_type_hierarchy = function(config)
    config = config or {}
    local cword = lua_utils.__trim_spaces(config.cword) or vim.fn.expand('<cWORD>')
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
