local sqlite = require('sqlite.db')
local utils = require('hopcsharp.database.utils')

local M = {}

local _db = nil

local URI = vim.fs.joinpath(vim.fn.stdpath('state'), utils.__get_db_file_name(vim.fn.getcwd()))

---@return sqlite_db @Main sqlite.lua object.
M.__init_db = function()
    return sqlite({
        uri = URI,
        files = {
            id = true,
            path = { type = 'text', unique = true },
        },
        namespaces = {
            id = true,
            name = { type = 'text', unique = true }
        },
        classes = {
            id = true,
            file_path_id = { type = 'integer', reference = 'files.id' },
            namespace_id = { type = 'integer', reference = 'namespaces.id' },
            name = 'text',
            row = 'integer',
            column = 'integer',
        },
        interfaces = {
            id = true,
            file_path_id = { type = 'integer', reference = 'files.id' },
            namespace_id = { type = 'integer', reference = 'namespaces.id' },
            name = 'text',
            row = 'integer',
            column = 'integer',
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

    _db = M.__init_db()

    return _db
end

M.__drop_db = function()
    local db = M.__get_db()
    db:eval('delete from classes')
    db:eval('delete from interfaces')
    db:eval('delete from files')
    db:eval('delete from namespaces')
    db:eval('vacuum')
end

return M
