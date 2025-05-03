local M = {}

--- @return string
M.__get_db_file_name = function(work_dir)
    return vim.fs.normalize(work_dir)
        :gsub('[:/]', '-')
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

return M
