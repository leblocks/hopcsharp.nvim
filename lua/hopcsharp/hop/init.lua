local utils = require('hopcsharp.hop.utils')
local database = require('hopcsharp.database')
local query = require('hopcsharp.database.query')

local M = {}

M.__hop_to_definition = function(callback)
    local db = database.__get_db()
    local cword = vim.fn.expand('<cword>')

    local rows = db:eval(query.get_definition_by_name, { name = cword })

    if type(rows) ~= 'table' then
        -- query found nothing
        return
    end

    if callback ~= nil then
        callback(rows)
        return
    end

    if #rows == 1 then
        utils.__hop(rows[1].path, rows[1].row + 1, rows[1].column)
        return
    end

    vim.ui.select(rows, {
        prompt = ' definitions >',
        format_item = function(row)
            return row.type .. '\t\t' .. row.namespace_name .. '\t\t' .. row.path
        end,
    }, function(choice)
        if choice ~= nil then
            utils.__hop(choice.path, choice.row + 1, choice.column)
        end
    end)
end

return M
