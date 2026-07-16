local database = require('hopcsharp.database')
local query = require('hopcsharp.database.query')
local utils = require('hopcsharp.hop.providers.utils')
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
    local name, node_type = utils.__get_node_type(current_word, node)

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
M.__by_name_type_and_used_namespaces = function(current_word, node)
    local name, node_type = utils.__get_node_type(current_word, node)

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

            local namespace = {}
            for _, nn, _, _ in treesitter_query.using_identifier:iter_captures(node, 0, 0, -1) do
                table.insert(namespace, vim.treesitter.get_node_text(nn, 0, nil))
            end

            local db = database.__get_db()
            return db:eval(query.get_definition_by_name_type_and_namespace(name, node_type, namespace))
        end,
    }
end

---@param current_word string Word under cursor
---@param node TSNode | nil Node under cursor
M.__by_name_type_and_current_namespace = function(current_word, node)
    local name, node_type = utils.__get_node_type(current_word, node)

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

            local namespace = {}
            for _, nn, _, _ in treesitter_query.namespace_identifier:iter_captures(node, 0, 0, -1) do
                table.insert(namespace, vim.treesitter.get_node_text(nn, 0, nil))
            end

            -- TODO cover in tests to make sure it is needed
            -- insert outer namespace that are not included by usings
            -- because namespace has access to all types defined in outer namespaces
            for _, n in ipairs(utils.__get_outer_namespaces(namespace[1] or '')) do
                table.insert(namespace, n)
            end

            local db = database.__get_db()
            return db:eval(query.get_definition_by_name_type_and_namespace(name, node_type, namespace))
        end,
    }
end

return M
