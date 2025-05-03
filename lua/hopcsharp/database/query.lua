local M = {}

M.get_class_by_name = [[
    SELECT
        c.name,
        n.name         AS namespace_name,
        f.path,
        c.row,
        c.column,
        'class'        AS type
    FROM classes c
    JOIN files f on f.id = c.file_path_id
    JOIN namespaces n on n.id = c.namespace_id
    WHERE c.name = :name
]]

M.get_attribute_by_name = [[
    SELECT
        c.name,
        n.name         AS namespace_name,
        f.path,
        c.row,
        c.column,
        'class'        AS type
    FROM classes c
    JOIN files f on f.id = c.file_path_id
    JOIN namespaces n on n.id = c.namespace_id
    WHERE c.name = concat(:name, 'Attribute')
]]


M.get_interface_by_name = [[
    SELECT
        i.name,
        n.name         AS namespace_name,
        f.path,
        i.row,
        i.column,
        'interface'    AS type
    FROM interfaces i
    JOIN files f on f.id = i.file_path_id
    JOIN namespaces n on n.id = i.namespace_id
    WHERE i.name = :name
]]


M.get_definition_by_name =
    M.get_class_by_name .. [[
        UNION ALL
    ]] .. M.get_interface_by_name .. [[
        UNION ALL
    ]] .. M.get_attribute_by_name

return M
