local utils = require('hopcsharp.utils')
local database = require('hopcsharp.database')
local tree = require('hopcsharp.hierarchy.tree')
local query = require('hopcsharp.database.query')

local M = {}

M.__get_type_parents = function(type_name)
    local db = database.__get_db()
    local type_relations = db:eval(query.get_all_parent_types, { type = type_name })

    if type(type_relations) ~= 'table' then
        return tree.__create_node(type_name, {})
    end

    local current = utils.__find_table(type_relations, 'name', type_name)

    if current == nil then
        return {}
    end

    local next = current

    -- go to the head of the hierarchy
    while next ~= nil do
        current = next
        next = utils.__find_first(type_relations, 'name', current.base)
    end

    return tree.__build_hierarchy_tree(current.base, type_relations)
end

M.__get_type_children = function(type_name)
    local db = database.__get_db()
    local type_relations = db:eval(query.get_all_child_types, { type = type_name })

    if type(type_relations) ~= 'table' then
        return tree.__create_node(type_name, {})
    end

    return tree.__build_hierarchy_tree(type_name, type_relations)
end

M.__connect_parent_and_child_hierarchies = function(parents, children)
    -- parents tree is a linked list
    -- so we can safely go down always by first child
    local function get_parents_leaf_node(node)
        if node == nil then
            return nil
        end

        if node.children == nil or #node.children == 0 then
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

