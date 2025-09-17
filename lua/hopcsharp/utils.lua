local M = {}

M.__find_table = function(tables, key, value)
    local result = {}
    for _, entry in ipairs(tables or {}) do
        if entry[key] == value then
            table.insert(result, entry)
        end
    end
    return result
end

M.__find_first = function(tables, key, value)
    return M.__find_table(tables, key, value)[1] or nil
end

M.__contains = function(entries, entry)
    for _, v in ipairs(entries or {}) do
        if v == entry then
            return true
        end
    end

    return false
end

M.__trim_spaces = function(word)
    if word == nil then
        return nil
    end
    return string.gsub(word, '%s+', '')
end

return M
