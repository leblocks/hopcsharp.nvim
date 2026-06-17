local query_utils = require('hopcsharp.parse.utils')
local database_utils = require('hopcsharp.database.utils')

local M = {}

---@param node TSNode | nil tree-sitter node
---@param parent_node TSNode | nil tree-sitter parent node
---@param parent_node_type string tree-sitter parent node type
local function find_node_parent_in_tree(node, parent_node, parent_node_type)
    if not node then
        return nil
    end

    if not parent_node then
        return nil
    end

    if parent_node:type() == parent_node_type then
        return parent_node
    end

    return find_node_parent_in_tree(node, parent_node:child_with_descendant(node), parent_node_type)
end

---@param node TSNode | nil tree-sitter node
M.__get_method_definition_parent_name = function(node)
    if node == nil then
        return nil
    end

    local parent_name = nil
    local parent_type = node:parent():type()

    if parent_type ~= 'method_declaration' then
        return nil
    end

    local tree = node:tree()
    local root = tree:root()

    local parent_node = find_node_parent_in_tree(node, root, 'class_declaration')
        or find_node_parent_in_tree(node, root, 'interface_declaration')

    if parent_node then
        local _query = query_utils.__get_query([[
                    [
                        (class_declaration name: (identifier) @name)
                        (interface_declaration name: (identifier) @name)
                    ]
                ]])

        -- query for declaration node name
        for _, nn, _, _ in _query:iter_captures(parent_node, 0, 0, -1) do
            parent_name = vim.treesitter.get_node_text(nn, 0, nil)
        end
    end

    return parent_name
end

---@param current_word string Word under cursor
---@param node TSNode | nil Node under cursor
M.__get_node_type = function(current_word, node)
    local node_type = nil
    if node then
        local parent_type = node:parent():type()

        if parent_type == 'attribute' then
            current_word = current_word .. 'Attribute'
            node_type = database_utils.types.CLASS
        end

        if parent_type == 'invocation_expression' then
            node_type = database_utils.types.METHOD
        end
    end

    return current_word, node_type
end

return M
