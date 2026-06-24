local database = require('hopcsharp.database')

local M = {}

M.__add_parse_history_entry = function(commit_hash)
    if commit_hash == nil then
        return
    end

    if commit_hash == '' then
        return
    end

    database.__get_db()
        :insert('parse_history', {
            parse_date = os.date('%Y-%m-%d %H:%M:%S'),
            commit_hash = commit_hash,
        })
end

M.__get_parse_history = function()
    return database.__get_db()
        :eval([[
            SELECT parse_date, commit_hash
            FROM parse_history
            ORDER BY parse_date DESC
            LIMIT 1
        ]])
end

return M
