local utils = require('hopcsharp.utils')
local database = require('hopcsharp.database')
local database_utils = require('hopcsharp.database.utils')
local tree = require('hopcsharp.hierarchy.tree')
local query = require('hopcsharp.database.query')

local M = {}

local function find_first_class(type_relations, type_name)
    local db = database.__get_db()
    for _, entry in ipairs(type_relations) do
        if entry['name'] == type_name then
            -- if current entry base type is a class -> bingo!
            local items = db:eval(
                query.get_definition_by_name_and_type,
                { name = entry['base'], type = database_utils.types.CLASS }
            )

            -- if we have found any class in result
            if type(items) == 'table' then
                return entry
            end
        end
    end

    -- we didn't find base class,
    -- fallback to default behaviour
    return utils.__find_first(type_relations, 'name', type_name)
end

find_first_class({}, {})

M.__get_type_parents = function(type_name)
    local db = database.__get_db()
    local type_relations = db:eval(query.get_all_parent_types, { type = type_name })

    if type(type_relations) ~= 'table' then
        return tree.__create_node(type_name, {})
    end

    local current = find_first_class(type_relations, type_name)

    if current == nil then
        return {}
    end

    local next = current

    local iterations_count = 0

    -- go to the head of the hierarchy
    while next ~= nil do
        -- break from cycles
        if iterations_count > 1000 then
            error('cycle detected for type hierarchy: ' .. type_name)
        else
            iterations_count = iterations_count + 1
        end

        current = next
        next = find_first_class(type_relations, current.base)
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
