local database = require('hopcsharp.database')
local dbutils = require('hopcsharp.database.utils')
local utils = require('hopcsharp.hop.providers.utils')
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
    local name, _ = utils.__get_node_type(current_word, node)

    while node ~= nil and node:type() ~= 'compilation_unit' do
        node = node:parent()
    end

    -- TODO make sure that definition is not internal
    -- internal modifier skips using\namespace checks and only
    -- checks if it is the same assembly

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

            local db = database.__get_db()
            return db:eval(query.get_reference_by_name_and_current_namespace(name, namespace))
        end,
    }
end

return M
