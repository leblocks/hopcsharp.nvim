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
    WHERE d.name = :name OR d.name LIKE :name || '<%>'
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
    WHERE (d.name = :name OR d.name = :name || 'Attribute' OR d.name LIKE :name || '<%>')
        AND d.type = :type
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

M.get_attributes = [[
    SELECT
        d.name,
        f.path,
        d.row,
        d.column,
        d.type
    FROM definitions d
    JOIN files f on f.id = d.path_id
    WHERE d.type = 1 AND d.name like '%Attribute'
    ORDER BY
        d.name ASC,
        f.path ASC
]]

-- have to add distinct here to avoid listing
-- classes that has the same name as :name but are not
-- implementing anything
M.get_implementations_by_name = [[
    SELECT DISTINCT
        d.name,
        f.path,
        d.row,
        d.column,
        d.type
    FROM inheritance i
    JOIN definitions d on d.name = i.name
    JOIN files f on f.id = d.path_id
    WHERE (i.base = :name OR i.base LIKE :name || '<%>')
        AND d.type <> 7 -- filter constructors
        AND d.type <> 6 -- filter methods
    ORDER BY
        d.name ASC,
        f.path ASC
]]

-- this is kind of a hack here
-- we get implementaiton defentions from defeinitions table
-- and after thath self join on itself by file id to get
-- method definitions in those types, assumption here is that
-- method with the same name as defined in a base class
-- most certainly will be in the same file as class implementations
-- I hope it is somewhat clear
M.get_method_implementation_by_parent_name_and_method_name = [[
    SELECT DISTINCT
        md.name,
        f.path,
        md.row,
        md.column,
        md.type
    FROM inheritance i
    JOIN definitions d on d.name = i.name
    JOIN files f on f.id = d.path_id
    JOIN definitions md on md.path_id = d.path_id
    WHERE md.name = :method_name
        AND i.base = :parent_type_name
        AND d.type <> 7 -- filter constructors
        AND md.type = 6 -- keep only methods
    ORDER BY
        md.name ASC,
        f.path ASC
]]

M.get_all_parent_types = [[
    WITH RECURSIVE parents(name, base) AS (
        SELECT i.name, i.base FROM inheritance i WHERE i.name = :type
        UNION
        SELECT i.name, i.base FROM parents p
        JOIN inheritance i ON p.base = i.name
        LIMIT 1000 -- limit stuff in case something goes wrong
    )
    SELECT DISTINCT name, base FROM parents WHERE base <> name;
]]

M.get_all_child_types = [[
    WITH RECURSIVE children(name, base) AS (
        SELECT i.name, i.base FROM inheritance i WHERE i.base = :type
        UNION
        SELECT i.name, i.base FROM children c
        JOIN inheritance i ON c.name = i.base
        LIMIT 1000 -- limit stuff in case something goes wrong
    )
    SELECT DISTINCT name, base FROM children WHERE base <> name;
]]

M.get_reference_by_name = [[
    SELECT
        r.name,
        f.path,
        r.row,
        r.column,
        r.type
    FROM reference r
    JOIN files f on f.id = r.path_id
    WHERE (r.name = :name OR r.name LIKE :name || '<%>')
    ORDER BY
        r.name ASC,
        f.path ASC
]]

M.get_reference_by_name_and_type = [[
    SELECT
        r.name,
        f.path,
        r.row,
        r.column,
        r.type
    FROM reference r
    JOIN files f on f.id = r.path_id
    WHERE (r.name = :name OR r.name LIKE :name || '<%>')
        AND r.type = :type
    ORDER BY
        r.name ASC,
        f.path ASC
]]

return M
