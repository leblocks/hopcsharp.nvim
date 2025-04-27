local sqlite = require('sqlite.db')
local os = require('os')
local Path = require('plenary.path')

local M = {}

local _db = nil

--- @return string
M.__get_db_file_name = function(work_dir)
    return vim.fs.normalize(work_dir)
        :gsub('[:/]', '-')
        :gsub('^-', '') .. '.sql'
end

local URI = vim.fs.joinpath(vim.fn.stdpath('state'), M.__get_db_file_name(vim.fn.getcwd()))

M.__delete_db = function()
    if vim.fn.filereadable(URI) == 1 then
        local result, reason = os.remove(URI)
        if not result then
            error('could not delete "' .. URI .. '" reason: ' .. reason)
        end
    end
end

---@return sqlite_db @Main sqlite.lua object.
M.__init_db = function()

    return sqlite({
        uri = URI,
        classes = {
            -- TODO dedupe schema, namespace and file_path are good candidates
            file_path = 'text',
            namespace = 'text',
            name = 'text',
            start_row = 'integer',
            start_column = 'integer',
        },
        opts = {},
    })
end

M.__open_db = function()
end

-- TODO some state management?
---@return sqlite_db @Main sqlite.lua object.
M.__get_db = function()

    if _db ~= nil then
        return _db
    end

    _db = M.__init_db()

    return _db
end

return M
