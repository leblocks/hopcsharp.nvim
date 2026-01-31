local database = require('hopcsharp.database')
local dbutils = require('hopcsharp.database.utils')
local query = require('hopcsharp.database.query')
local treesitter_query = require('hopcsharp.parse.query')

local M = {}

---@param current_word string Word under cursor
---@param _ TSNode | nil Node under cursor
M.__by_name = function(current_word, _)
    return {
        can_handle = function()
            return true
        end,
        get_hops = function()
            local db = database.__get_db()
            return db:eval(query.get_definition_by_name(current_word))
        end,
    }
end

---@param current_word string Word under cursor
---@param node TSNode | nil Node under cursor
M.__by_name_and_type = function(current_word, node)
    local node_type = nil
    local name = current_word

    if node then
        local parent_type = node:parent():type()

        if parent_type == 'attribute' then
            name = name .. 'Attribute'
            node_type = dbutils.types.CLASS
        end

        if parent_type == 'invocation_expression' then
            node_type = dbutils.types.METHOD
        end
    end

    return {

        can_handle = function()
            return node_type ~= nil
        end,

        get_hops = function()
            local db = database.__get_db()
            return db:eval(query.get_definition_by_name_and_type(name, node_type))
        end,
    }
end

---@param current_word string Word under cursor
---@param node TSNode | nil Node under cursor
M.__by_name_and_used_namespaces = function(current_word, node)
    while node ~= nil and node:type() ~= 'compilation_unit' do
        node = node:parent()
    end

    return {
        can_handle = function()
            return node ~= nil
        end,

        get_hops = function()
            if node == nil then
                return {}
            end

            local usings = {}
            for _, nn, _, _ in treesitter_query.using_identifier:iter_captures(node, 0, 0, -1) do
                table.insert(usings, vim.treesitter.get_node_text(nn, 0, nil))
            end

            local db = database.__get_db()
            return db:eval(query.get_definition_by_name_and_usings(current_word, usings))
        end,
    }
end

return M
