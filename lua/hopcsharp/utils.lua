
local M = {}

-- TODO docs + test
M.__find_table = function(tables, key, value)
    local result = {}
    for _, _table in ipairs(tables) do
        if _table[key] == value then
            table.insert(result, _table)
        end
    end
    return result
end

-- TODO docs + test
M.__find_first = function(tables, key, value)
    return M.__find_table(tables, key, value)[1] or {}
end

-- TODO docs + test
M.__contains = function(entries, entry)
    for _, _entry in ipairs(entries) do
        if _entry == entry then
            return true
        end
    end

    return false
end

return M

