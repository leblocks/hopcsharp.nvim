local M = {}

--- @return string
M.__get_db_file_name = function(work_dir)
    return vim.fs.normalize(work_dir)
        :gsub('[:/\\]', '-')
        :gsub('^-', '') .. '.sql'
end

M.__insert_unique = function(db, table_name, query)
    local rows = db:select(table_name, { where = query })

    if #rows > 0 then
        return rows[1].id
    end

    local success, id = db:insert(table_name, query)

    if not success then
        error('failed to insert into ' .. table_name .. ' with query ' .. vim.inspect(query))
    end

    return id
end

M.__types = {
    CLASS = 1,
    INTERFACE = 2,
    STRUCT = 3,
    RECORD = 4,
    ENUM = 5,
    METHOD = 6,
    CONSTRUCTOR = 7,
}

M.__get_type_name = function(type)
    if type == M.__types.CLASS then
        return 'class'
    end

    if type == M.__types.INTERFACE then
        return 'interface'
    end

    if type == M.__types.STRUCT then
        return 'struct'
    end

    if type == M.__types.RECORD then
        return 'record'
    end

    if type == M.__types.ENUM then
        return 'enum'
    end

    if type == M.__types.METHOD then
        return 'method'
    end

    if type == M.__types.CONSTRUCTOR then
        return 'constructor'
    end
end

return M
