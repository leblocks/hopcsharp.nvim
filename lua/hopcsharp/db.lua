local sqlite = require('sqlite.db')
local os = require('os')

local M = {}

local _db = nil

M.__get_db_file_name = function(work_dir)
    return vim.fs.normalize(work_dir)
        :gsub('[:/]', '-')
        :gsub('^-', '') .. '.sql'
end

M.__get_path_to_db_folder = function()
    return vim.fs.joinpath(vim.fn.stdpath('state'), 'hopcsharp')
end

local URI = vim.fs.joinpath(M.__get_path_to_db_folder(), M.__get_db_file_name(vim.fn.getcwd()))

M.__delete_db = function()
    if vim.fn.filereadable(URI) == 1 then
        local result, reason = os.remove(URI)
        if not result then
            error('could not delete "' .. URI .. '" reason: ' .. reason)
        end
    end
end

M.__init_db = function()
    return sqlite({
        uri = URI,
        classes = {
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
-- TODO propagate types
M.__get_db = function()

    if _db ~= nil then
        return _db
    end

    _db = M.__init_db()

    return _db
end

return M
