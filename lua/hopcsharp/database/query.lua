local M = {}

M.get_definition_by_name = [[
    SELECT
        d.name,
        f.path,
        d.row,
        d.column,
        d.type
    FROM definitions d
    JOIN files f on f.id = d.path_id
    WHERE d.name = :name
    ORDER BY
        f.path ASC
]]

M.get_definition_by_name_and_type = [[
    SELECT
        d.name,
        f.path,
        d.row,
        d.column,
        d.type
    FROM definitions d
    JOIN files f on f.id = d.path_id
    WHERE (d.name = :name OR d.name = concat(:name, 'Attribute')) AND d.type = :type
]]

M.get_all_definitions = [[
    SELECT
        d.name,
        f.path,
        d.row,
        d.column,
        d.type
    FROM definitions d
    JOIN files f on f.id = d.path_id
    ORDER BY
        d.name ASC,
        f.path ASC
]]


M.get_definition_by_type = [[
    SELECT
        d.name,
        f.path,
        d.row,
        d.column,
        d.type
    FROM definitions d
    JOIN files f on f.id = d.path_id
    WHERE d.type = :type
    ORDER BY
        d.name ASC,
        f.path ASC
]]

M.get_implementations_by_name = [[
    SELECT
        d.name,
        f.path,
        d.row,
        d.column,
        d.type
    FROM inheritance i
    JOIN definitions d on d.name = i.name
    JOIN files f on f.id = d.path_id
    WHERE i.base = :name AND d.type <> 7 -- filter constructors
    ORDER BY
        d.name ASC,
        f.path ASC
]]


return M
