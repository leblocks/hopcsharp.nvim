local utils = require('hopcsharp.hop.utils')
local database = require('hopcsharp.database')
local dbutils = require('hopcsharp.database.utils')
local query = require('hopcsharp.database.query')
local qutils = require('hopcsharp.parse.utils')

local M = {}

local function find_node_parent_in_tree(node, parent_node, parent_node_type)
    if not node then
        return nil
    end

    if not parent_node then
        return nil
    end

    if parent_node:type() == parent_node_type then
        return parent_node
    end

    return find_node_parent_in_tree(node, parent_node:child_with_descendant(node), parent_node_type)
end

M.__hop_to_definition = function(callback)
    local db = database.__get_db()
    local cword = vim.fn.expand('<cword>')

    local node = vim.treesitter.get_node()
    local node_type = nil

    if node then
        local parent_type = node:parent():type()

        if parent_type == 'attribute' then
            cword = cword .. 'Attribute'
            node_type = dbutils.types.CLASS
        end

        if parent_type == 'invocation_expression' then
            node_type = dbutils.types.METHOD
        end
    end

    local definitions
    if node_type ~= nil then
        definitions = db:eval(query.get_definition_by_name_and_type, { name = cword, type = node_type })
    else
        definitions = db:eval(query.get_definition_by_name, { name = cword })
    end

    -- query found nothing
    if type(definitions) ~= 'table' then
        return
    end

    -- filter out current position
    local filtered_definitions = {}
    local current_line = vim.fn.getcurpos()[2] -- 2 for line number
    local current_file = vim.fs.normalize(vim.fn.expand('%:p'))
    for _, definition in ipairs(definitions) do
        if (definition.row + 1) == current_line then
            local full_path = vim.fs.joinpath(vim.fn.getcwd(), definition.path)
            if current_file == full_path then
                goto continue
            end
        end
        table.insert(filtered_definitions, definition)
        ::continue::
    end

    if #filtered_definitions == 0 then
        return
    end

    if callback ~= nil then
        -- user provided custom logic for navigation
        -- execute and return
        callback(filtered_definitions)
        return
    end

    -- immediate jump if there is only one case
    if #filtered_definitions == 1 then
        utils.__hop(filtered_definitions[1].path, filtered_definitions[1].row + 1, filtered_definitions[1].column)
        return
    end

    -- sent to quickfix if there is too much
    if #filtered_definitions > 1 then
        local qflist = {}
        for _, definition in ipairs(filtered_definitions) do
            table.insert(qflist, {
                filename = definition.path,
                lnum = definition.row + 1,
                col = definition.col,
                text = dbutils.get_type_name(definition.type),
            })
        end

        vim.fn.setqflist(qflist, 'r')
        vim.cmd([[ :copen ]])
        return
    end
end

M.__hop_to_implementation = function(callback)
    local db = database.__get_db()
    local cword = vim.fn.expand('<cword>')

    -- handle case when current node is method defintion
    local node = vim.treesitter.get_node()
    local parent_name = M.__get_method_definition_parent_name(node)

    local implementations

    if parent_name then
        implementations = db:eval(
            query.get_method_implementation_by_parent_name_and_method_name,
            { parent_type_name = parent_name, method_name = cword }
        )
    else
        implementations = db:eval(query.get_implementations_by_name, { name = cword })
    end

    -- query found nothing
    if type(implementations) ~= 'table' then
        return
    end

    -- filter out current position
    local filtered_implementations = {}
    local current_line = vim.fn.getcurpos()[2] -- 2 for line number
    local current_file = vim.fs.normalize(vim.fn.expand('%:p'))
    for _, implementation in ipairs(implementations) do
        if (implementation.row + 1) == current_line then
            local full_path = vim.fs.joinpath(vim.fn.getcwd(), implementation.path)
            if current_file == full_path then
                goto continue
            end
        end
        table.insert(filtered_implementations, implementation)
        ::continue::
    end

    if callback ~= nil then
        -- user provided custom logic for navigation
        -- execute and return
        callback(filtered_implementations)
        return
    end

    -- immediate jump if there is only one case
    if #filtered_implementations == 1 then
        utils.__hop(
            filtered_implementations[1].path,
            filtered_implementations[1].row + 1,
            filtered_implementations[1].column
        )
        return
    end

    -- sent to quickfix if there is too much
    if #filtered_implementations > 1 then
        local qflist = {}
        for _, implementation in ipairs(filtered_implementations) do
            table.insert(qflist, {
                filename = implementation.path,
                lnum = implementation.row + 1,
                col = implementation.col,
                text = dbutils.get_type_name(implementation.type) .. ' ' .. implementation.name,
            })
        end

        vim.fn.setqflist(qflist, 'r')
        vim.cmd([[ :copen ]])
        return
    end
end

M.__get_method_definition_parent_name = function(node)
    if node == nil then
        return nil
    end

    local parent_name = nil
    local parent_type = node:parent():type()
    if parent_type ~= 'method_declaration' then
        return nil
    end

    local tree = node:tree()

    local parent_node = find_node_parent_in_tree(node, tree:root(), 'class_declaration')
        or find_node_parent_in_tree(node, tree:root(), 'interface_declaration')

    if parent_node then
        local _query = qutils.__get_query([[
                    [
                        (class_declaration name: (identifier) @name)
                        (interface_declaration name: (identifier) @name)
                    ]
                ]])

        -- query for declaration node name
        for _, nn, _, _ in _query:iter_captures(parent_node, 0, 0, -1) do
            parent_name = vim.treesitter.get_node_text(nn, 0, nil)
        end
    end

    return parent_name
end

return M
