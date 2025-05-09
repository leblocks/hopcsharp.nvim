local M = {}

M.get_definition_by_name = [[
    SELECT
        d.name,
        n.name         AS namespace,
        f.path,
        d.row,
        d.column,
        d.type
    FROM definitions d
    JOIN files f on f.id = d.path_id
    JOIN namespaces n on n.id = d.namespace_id
    WHERE d.name = :name OR d.name = concat(:name, 'Attribute')
    ORDER BY
        f.path ASC
]]

M.get_definition_by_name_and_type = [[
    SELECT
        d.name,
        n.name         AS namespace,
        f.path,
        d.row,
        d.column,
        d.type
    FROM definitions d
    JOIN files f on f.id = d.path_id
    JOIN namespaces n on n.id = d.namespace_id
    WHERE (d.name = :name OR d.name = concat(:name, 'Attribute')) AND d.type = :type
]]

M.get_all_definitions = [[
    SELECT
        d.name,
        n.name         AS namespace,
        f.path,
        d.row,
        d.column,
        d.type
    FROM definitions d
    JOIN files f on f.id = d.path_id
    JOIN namespaces n on n.id = d.namespace_id
    ORDER BY
        d.name ASC,
        f.path ASC
]]


return M
