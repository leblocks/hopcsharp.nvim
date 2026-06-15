local database = require('hopcsharp.database')
local query = require('hopcsharp.database.query')
local utils = require('hopcsharp.hop.providers.utils')

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
            return db:eval(query.get_implementations_by_name(current_word))
        end,
    }
end

---@param current_word string Word under cursor
---@param node TSNode | nil Node under cursor
M.__by_parent_name_and_method_name = function(current_word, node)
    local parent_name = utils.__get_method_definition_parent_name(node)
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
