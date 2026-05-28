local os = require('os')
local sqlite = require('sqlite.db')
local config = require('hopcsharp.config')
local utils = require('hopcsharp.debug.utils')

local M = {}

local _db = nil

---@return sqlite_db @Main sqlite.lua object.
local function __init_db()
    return sqlite({
        uri = vim.fs.joinpath(vim.fn.stdpath('state'), 'hopcsharp.debug.sql'),
        logs = {
            -- Use the TEXT storage class to store dates in the ISO8601 format: YYYY-MM-DD HH:MM:SS.SSS.
            date = { type = 'text' },
            project = { type = 'text' },
            message = { type = 'text' },
            level = { type = 'integer' },
        },
        opts = {
            keep_open = true,
        },
    })
end

---@return sqlite_db @Main sqlite.lua object.
M.__get_db = function()
    if _db ~= nil then
        return _db
    end

    _db = __init_db()

    return _db
end

M.__log = function(message, level)

    if not config.__get_config().debug then
        return
    end

    level = level or utils.level.INFO;

    M.__get_db():insert('logs', {
        level = level,
        message = message,
        project = vim.fn.getcwd(),
        -- YYYY-MM-DD HH:MM:SS.SSS
        date = os.date('%Y-%m-%d %H:%M:%S.000'),
    })
end

return M

