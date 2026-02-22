local M = {}

--- @return string
M.__get_db_file_name = function(work_dir)
    return vim.fs.normalize(work_dir):gsub('[:/\\]', '-'):gsub('^-', '') .. '.sql'
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

M.types = {
    CLASS = 1,
    INTERFACE = 2,
    STRUCT = 3,
    RECORD = 4,
    ENUM = 5,
    METHOD = 6,
    CONSTRUCTOR = 7,
}

M.reference_types = {
    METHOD_INVOCATION = 1,
    OBJECT_CREATION = 2,
    ATTRIBUTE = 3,
    VARIABLE_DECLARATION = 4,
    TYPE_ARGUMENT = 5,
    TYPEOF_EXPRESSION = 6,
}

M.get_type_name = function(type)
    if type == M.types.CLASS then
        return 'class'
    end

    if type == M.types.INTERFACE then
        return 'interface'
    end

    if type == M.types.STRUCT then
        return 'struct'
    end

    if type == M.types.RECORD then
        return 'record'
    end

    if type == M.types.ENUM then
        return 'enum'
    end

    if type == M.types.METHOD then
        return 'method'
    end

    if type == M.types.CONSTRUCTOR then
        return 'constructor'
    end
end

M.get_reference_type_name = function(type)
    if type == M.reference_types.ATTRIBUTE then
        return 'attribute'
    end

    if type == M.reference_types.METHOD_INVOCATION then
        return 'method'
    end

    if type == M.reference_types.OBJECT_CREATION then
        return 'object'
    end

    if type == M.reference_types.VARIABLE_DECLARATION then
        return 'variable'
    end

    if type == M.reference_types.TYPE_ARGUMENT then
        return 'type'
    end

    if type == M.reference_types.TYPEOF_EXPRESSION then
        return 'type'
    end
end

M.__get_definitions_insert_command = function(entries)
    return M.__get_insert_command('definitions', entries)
end

M.__get_references_insert_command = function(entries)
    return M.__get_insert_command('reference', entries)
end

-- TODO tests
M.__get_inheritance_insert_command = function(entries)
    if entries == nil or #entries == 0 then
        return ""
    end
    local values = {}
    for _, entry in ipairs(entries) do
        local value = string.format('(%s, %s, "%s", "%s")', entry.path_id, entry.namespace_id, entry.name, entry.base)
        table.insert(values, value)
    end

    local template = "INSERT INTO inheritance (path_id, namespace_id, name, base) VALUES %s;"
    return string.format(template, table.concat(values, ','));
end

M.__get_insert_command = function(table_name, entries)
    if entries == nil or #entries == 0 then
        return ""
    end
    local values = {}
    for _, entry in ipairs(entries) do
        local value = string.format('(%s, %s, %s, "%s", %s, %s)', entry.path_id, entry.namespace_id, entry.type,
            entry.name, entry.row, entry.column)
        table.insert(values, value)
    end

    local template = "INSERT INTO %s (path_id, namespace_id, type, name, row, column) VALUES %s;"
    return string.format(template, table_name, table.concat(values, ','));
end

return M
