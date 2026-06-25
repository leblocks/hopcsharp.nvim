local database = require('hopcsharp.database')

local M = {}

M.__add_parse_history_entry = function(commit_hash)
    if commit_hash == nil then
        return
    end

    if commit_hash == '' then
        return
    end

    database.__get_db():insert('parse_history', { commit_hash = commit_hash, })
end

M.__get_last_parsed_commit = function()
    local rows = database.__get_db()
        :eval([[
            SELECT id, commit_hash
            FROM parse_history
            ORDER BY id DESC
            LIMIT 1
        ]])

    if type(rows) ~= 'table' then
        return ''
    end

    return rows[1].commit_hash
end

return M
