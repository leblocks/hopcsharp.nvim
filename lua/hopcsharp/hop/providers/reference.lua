local database = require('hopcsharp.database')
local query = require('hopcsharp.database.query')


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
            return db:eval(query.get_reference_by_name, { name = current_word })
        end,
    }
end

return M
