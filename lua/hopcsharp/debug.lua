local sqlite = require('sqlite.db')
-- TODO implement a separate db connection
-- for separate db to write there logs
local M = {}

local _db = nil

-- TODO can be local
---@return sqlite_db @Main sqlite.lua object.
M.__init_db = function()
    return sqlite({
        uri = 'TODO',
        logs = {
            -- Use the TEXT storage class to store dates in the ISO8601 format: YYYY-MM-DD HH:MM:SS.SSS.
            date = { type = 'text', },
            project = { type = 'text' },
            message = { type = 'text' },
        },
        opts = {
            keep_open = true,
        },
    })
end

-- TODO can be local
---@return sqlite_db @Main sqlite.lua object.
M.__get_db = function()
    if _db ~= nil then
        return _db
    end

    _db = M.__init_db()
end

M.__log = function(message, level)
    -- TODO
    -- TODO do we need level?
end

return M
