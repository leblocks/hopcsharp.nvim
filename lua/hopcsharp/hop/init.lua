local utils = require('hopcsharp.hop.utils')
local database = require('hopcsharp.database')
local dbutils = require('hopcsharp.database.utils')
local query = require('hopcsharp.database.query')

local M = {}

M.__hop_to_definition = function(callback)
    local db = database.__get_db()
    local cword = vim.fn.expand('<cword>')

    local node = vim.treesitter.get_node()
    local node_type = nil

    if node then
        local parent_type = node:parent():type()

        if parent_type == 'attribute' then
            cword = cword .. 'Attribute'
            node_type = dbutils.__types.CLASS
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
                text = dbutils.__get_type_name(definition.type),
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

    local implementations = db:eval(query.get_implementations_by_name, { name = cword })

    -- query found nothing
    if type(implementations) ~= 'table' then
        return
    end

    if callback ~= nil then
        -- user provided custom logic for navigation
        -- execute and return
        callback(implementations)
        return
    end

    -- immediate jump if there is only one case
    if #implementations == 1 then
        utils.__hop(implementations[1].path, implementations[1].row + 1, implementations[1].column)
        return
    end

    -- sent to quickfix if there is too much
    if #implementations > 1 then
        local qflist = {}
        for _, implementation in ipairs(implementations) do
            table.insert(qflist, {
                filename = implementation.path,
                lnum = implementation.row + 1,
                col = implementation.col,
                text = dbutils.__get_type_name(implementation.type) .. ' ' .. implementation.name,
            })
        end

        vim.fn.setqflist(qflist, 'r')
        vim.cmd([[ :copen ]])
        return
    end
end

return M
