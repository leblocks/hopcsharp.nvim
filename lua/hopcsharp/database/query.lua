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

M.get_enum_by_name = [[
    SELECT
        e.name,
        n.name         AS namespace_name,
        f.path,
        e.row,
        e.column,
        'enum'         AS type
    FROM enums e
    JOIN files f on f.id = e.file_path_id
    JOIN namespaces n on n.id = e.namespace_id
    WHERE e.name = :name
]]

M.get_struct_by_name = [[
    SELECT
        s.name,
        n.name         AS namespace_name,
        f.path,
        s.row,
        s.column,
        'struct'       AS type
    FROM structs s
    JOIN files f on f.id = s.file_path_id
    JOIN namespaces n on n.id = s.namespace_id
    WHERE s.name = :name
]]

M.get_record_by_name = [[
    SELECT
        r.name,
        n.name         AS namespace_name,
        f.path,
        r.row,
        r.column,
        'record'       AS type
    FROM records r
    JOIN files f on f.id = r.file_path_id
    JOIN namespaces n on n.id = r.namespace_id
    WHERE r.name = :name
]]

M.get_definition_by_name =
    M.get_class_by_name .. [[
        UNION ALL
    ]] .. M.get_interface_by_name .. [[
        UNION ALL
    ]] .. M.get_attribute_by_name .. [[
        UNION ALL
    ]] .. M.get_enum_by_name .. [[
        UNION ALL
    ]] .. M.get_struct_by_name .. [[
        UNION ALL
    ]] .. M.get_record_by_name

return M
