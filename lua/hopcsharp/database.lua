local sqlite = require('sqlite.db')

local M = {}

local _db = nil

--- @return string
M.__get_db_file_name = function(work_dir)
    return vim.fs.normalize(work_dir)
        :gsub('[:/]', '-')
        :gsub('^-', '') .. '.sql'
end

local URI = vim.fs.joinpath(vim.fn.stdpath('state'), M.__get_db_file_name(vim.fn.getcwd()))

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
    db:eval("delete from classes")
    db:eval("delete from interfaces")
    db:eval("delete from namespaces")
    db:eval("delete from files")
    db:eval("vacuum")
end

---@param db sqlite_db db object
---@param path string file path
---@return integer id of inserted file_path
M.__insert_file = function(db, path)
    local rows = db:select('files', { where = { path = path } })

    if #rows > 0 then
        return rows[1].id
    end

    local success, id = db:insert('files', { path = path })

    if not success then
        error('failed to insert file: ' .. path)
    end

    return id
end

---@param db sqlite_db db object
---@param name string namespace name
---@return integer id of inserted file_path
M.__insert_namespace = function(db, name)
    local rows = db:select('namespaces', { where = { name = name } })

    if #rows > 0 then
        return rows[1].id
    end

    local success, id = db:insert('namespaces', { name = name })

    if not success then
        error('failed to insert namespace: ' .. name)
    end

    return id
end


return M
