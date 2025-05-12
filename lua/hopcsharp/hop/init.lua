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

    local rows = nil

    if node_type ~= nil then
        rows = db:eval(query.get_definition_by_name_and_type, { name = cword, type = node_type })
    else
        rows = db:eval(query.get_definition_by_name, { name = cword })
    end

    if type(rows) ~= 'table' then
        -- query found nothing
        return
    end

    if callback ~= nil then
        callback(rows)
        return
    end

    -- immediate jump if there is only one case
    if #rows == 1 then
        utils.__hop(rows[1].path, rows[1].row + 1, rows[1].column)
        return
    end

    -- sent to quickfix if there is too much
    if #rows > 5 then
        local qflist = {}
        for _, row in ipairs(rows) do
            table.insert(qflist, { filename = row.path, lnum = row.row + 1, col = row.col, text = dbutils.__get_type_name(row.type) .. " " .. row.namespace })
        end

        vim.fn.setqflist(qflist, 'r')
        vim.cmd([[ :copen ]])
        return
    end

    vim.ui.select(rows, {
        prompt = string.format('%s >', cword),
        format_item = function(row)
            return utils.__format_entry(dbutils.__get_type_name(row.type), row.path)
        end,
    }, function(choice)
        if choice ~= nil then
            utils.__hop(choice.path, choice.row + 1, choice.column)
        end
    end)
end

return M
