local M = {}

M.get_object_by_name = [[
    SELECT
        n.name         AS namespace,
        f.path,
        o.name,
        o.row,
        o.column,
        o.type
    FROM objects o
    JOIN files f on f.id = o.file_path_id
    JOIN namespaces n on n.id = o.namespace_id
    WHERE o.name = :name
]]

M.get_attribute_by_name = [[
    SELECT
        o.name,
        n.name         AS namespace,
        f.path,
        o.row,
        o.column,
        o.type
    FROM objects o
    JOIN files f on f.id = o.file_path_id
    JOIN namespaces n on n.id = o.namespace_id
    WHERE o.name = concat(:name, 'Attribute') and o.type = 1
]]

M.get_method_by_name = [[
    SELECT
        m.name,
        n.name      AS namespace,
        f.path,
        m.row,
        m.column,
        m.type
    FROM methods m
    JOIN objects o on o.id = m.parent_id
    JOIN files f on f.id = o.file_path_id
    JOIN namespaces n on n.id = o.namespace_id
    WHERE m.name = :name
]]

M.get_definition_by_name =
    M.get_attribute_by_name .. [[
        UNION ALL
    ]] .. M.get_object_by_name .. [[
        UNION ALL
    ]] .. M.get_method_by_name

return M
