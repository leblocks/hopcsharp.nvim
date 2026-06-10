local debug = require('hopcsharp.debug')

local M = {}

---Thin wrapper around an `sqlite_db` object that logs every call through the
---debug logger before delegating to the wrapped database.
---@class HopcsharpDatabaseWrapper wrapper around sqlite_db object

local inspect = function(obj)
    return vim.inspect(obj, { newline = ' ', indent = '' })
end

--- self added to not update whole codebase replacing db: with db.
---@param sqlite_db @Main sqlite.lua object.
---@return HopcsharpDatabaseWrapper
local wrap = function(db)
    return {
        eval = function(self, statement, params)
            local message = 'eval ' .. statement

            if params ~= nil then
                message = message .. ' ' .. inspect(params)
            end

            debug.__log_debug(message)
            return db:eval(statement, params)
        end,

        execute = function(self, statement)
            debug.__log_debug('execute ' .. statement)
            return db:execute(statement)
        end,

        select = function(self, tbl, query)
            debug.__log_debug('select ' .. tbl .. ' ' .. inspect(query))
            return db:select(tbl, query)
        end,

        delete = function(self, tbl, query)
            debug.__log_debug('delete ' .. tbl .. ' ' .. inspect(query))
            return db:delete(tbl, query)
        end,

        insert = function(self, tbl, rows)
            debug.__log_debug('insert ' .. tbl .. ' ' .. inspect(rows))
            return db:insert(tbl, rows)
        end,
    }
end

M.__get_wrapper = function(db)
    return wrap(db)
end

return M
