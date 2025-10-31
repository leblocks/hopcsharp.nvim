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
        definitions = {
            path_id = { type = 'integer', reference = 'files.id' },
            type = 'integer',
            name = 'text',
            row = 'integer',
            column = 'integer',
        },
        inheritance = {
            path_id = { type = 'integer', reference = 'files.id' },
            name = 'text',
            base = 'text',
        },
        reference = {
            path_id = { type = 'integer', reference = 'files.id' },
            type = 'integer',
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
    db:eval('delete from definitions')
    db:eval('delete from inheritance')
    db:eval('delete from reference')
    db:eval('delete from files')
    db:eval('vacuum')
end

M.__drop_by_path = function(paths)
    if paths == nil or #paths == 0 then
        return
    end

    local db = M.__get_db()
    local files = db:select('files', { where = { path = paths } })

    if #files == 0 then
        return
    end

    local ids = {}
    for _, file in ipairs(files) do
        table.insert(ids, file.id)
    end

    db:delete('files', { where = { id = ids } })
    db:delete('reference', { where = { path_id = ids } })
    db:delete('inheritance', { where = { path_id = ids } })
    db:delete('definitions', { where = { path_id = ids } })
end

return M
