local M = {}

-- TODO docs + test
M.__find_table = function(tables, key, value)
    local result = {}
    for _, entry in ipairs(tables) do
        if entry[key] == value then
            table.insert(result, entry)
        end
    end
    return result
end

-- TODO docs + test
-- cover in tests [1] out of bound case
M.__find_first = function(tables, key, value)
    return M.__find_table(tables, key, value)[1] or nil
end

-- TODO docs + test
M.__contains = function(entries, entry)
    for _, v in ipairs(entries) do
        if v == entry then
            return true
        end
    end

    return false
end

return M
