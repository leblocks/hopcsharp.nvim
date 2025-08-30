local utils = require('hopcsharp.hierarchy.utils')
local buffer = require('hopcsharp.hierarchy.buffer')

local M = {}

M.__get_type_hierarchy = function()
    -- TODO bail out if parent is empty
    -- and children is empty as well
    -- TODO fix endless loop in some cases
    local cword = vim.fn.expand('<cword>')
    local parents = utils.__get_type_parents(cword)
    local children = utils.__get_type_children(cword)
    utils.__connect_parent_and_child_hierarchies(parents, children)
    buffer.__create_hierarchy_buffer(cword, parents)
end

return M
