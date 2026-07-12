local database = require('hopcsharp.database')
local dbutils = require('hopcsharp.database.utils')
local provider_utils = require('hopcsharp.hop.providers.utils')
local utils = require('hopcsharp.utils')
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
            return db:eval(query.get_reference_by_name(current_word)), dbutils.get_reference_type_name
        end,
    }
end

--- known limitation, you have to stay on definition to properly
--- search by current namespace
---@param current_word string Word under cursor
---@param node TSNode | nil Node under cursor
M.__by_name_and_current_namespace = function(current_word, node)
    local name, _ = provider_utils.__get_node_type(current_word, node)

    local modifiers = {}

    if node ~= nil then
        modifiers = provider_utils.__get_node_modifiers(node)
    end

    while node ~= nil and node:type() ~= 'compilation_unit' do
        node = node:parent()
    end

    return {
        can_handle = function()
            if node == nil then
                return false
            end

            if utils.__contains(modifiers, 'internal') then
                -- internal modifier skips using\namespace checks and only
                -- checks if it is the same assembly
                return false
            end

            return true
        end,
        get_hops = function()
            if node == nil then
                return {}
            end

            local namespace = {}
            for _, nn, _, _ in treesitter_query.namespace_identifier:iter_captures(node, 0, 0, -1) do
                table.insert(namespace, vim.treesitter.get_node_text(nn, 0, nil))
            end

            local db = database.__get_db()
            return db:eval(query.get_reference_by_name_and_current_namespace(name, namespace))
        end,
    }
end

return M
