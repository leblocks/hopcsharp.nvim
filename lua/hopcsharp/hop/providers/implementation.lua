local database = require('hopcsharp.database')
local query = require('hopcsharp.database.query')
local query_utils = require('hopcsharp.parse.utils')

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

local function get_method_definition_parent_name(node)
    if node == nil then
        return nil
    end

    local parent_name = nil
    local parent_type = node:parent():type()

    if parent_type ~= 'method_declaration' then
        return nil
    end

    local tree = node:tree()

    local parent_node = find_node_parent_in_tree(node, tree:root(), 'class_declaration')
        or find_node_parent_in_tree(node, tree:root(), 'interface_declaration')

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

local M = {}

---@param current_word string Word under cursor
---@param node TSNode | nil Node under cursor
M.__by_name = function(current_word, node)
    return {
        can_handle = function()
            return true
        end,
        get_hops = function()
            local db = database.__get_db()
            return db:eval(query.get_implementations_by_name, { name = current_word })
        end,
    }
end

---@param current_word string Word under cursor
---@param node TSNode | nil Node under cursor
M.__by_parent_name_and_method_name = function(current_word, node)
    local parent_name = get_method_definition_parent_name(node)
    return {
        can_handle = function()
            return parent_name ~= nil
        end,
        get_hops = function()
            local db = database.__get_db()
            return db:eval(
                query.get_method_implementation_by_parent_name_and_method_name,
                { parent_type_name = parent_name, method_name = current_word }
            )
        end,
    }
end

return M
