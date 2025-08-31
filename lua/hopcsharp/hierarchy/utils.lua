local database = require('hopcsharp.database')
local query = require('hopcsharp.database.query')

local M = {}

local function find_all(entries, key, value)
    local result = {}
    for _, entry in ipairs(entries) do
        if entry[key] == value then
            table.insert(result, entry)
        end
    end
    return result
end

local function find_single(entries, key, value)
    return find_all(entries, key, value)[1] or nil
end

local function build_type_hierarchy_down(node, types)
    local children = find_all(types, 'base', node.name)

    node.children = {}
    for _, child in ipairs(children) do
        table.insert(node.children, { name = child.name })
    end

    for _, child in ipairs(node.children) do
        build_type_hierarchy_down(child, types)
    end
end

M.__get_type_parents = function(type_name)
    local db = database.__get_db()
    local parents = db:eval(query.get_all_parent_types, { type = type_name })

    if type(parents) ~= 'table' then
        return { name = type_name, children = {} }
    end

    local current = find_single(parents, 'name', type_name)

    if current == nil then
        return {}
    end

    local next = current

    -- go to the head of the hierarchy
    while next ~= nil do
        current = next
        next = find_single(parents, 'name', current.base)
    end

    -- now head of hierarchy is in current.base
    -- prepare tree root
    local root = { name = current.base, children = {} }

    build_type_hierarchy_down(root, parents)

    return root
end

M.__get_type_children = function(type_name)
    local db = database.__get_db()
    local children = db:eval(query.get_all_child_types, { type = type_name })
    local root = { name = type_name, children = {} }

    if type(children) ~= 'table' then
        return root
    end

    build_type_hierarchy_down(root, children)

    return root
end

M.__connect_parent_and_child_hierarchies = function(parents, children)
    -- parents tree is a linked list
    -- so we can safely go down always by first child
    local function get_parents_leaf_node(node)
        if node == nil then
            return nil
        end

        if #node.children == 0 then
            return node
        end

        return get_parents_leaf_node(node.children[1])
    end

    local parent = get_parents_leaf_node(parents)

    if parent and parent.name ~= children.name then
        error('hierarchies does not match')
    end

    -- connect nodes
    parent.children = children.children
end

return M
