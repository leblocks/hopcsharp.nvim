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

M.__block_on_processing = function(callback)
    local message = 'init_database is running, try again later. '
        .. 'If init_database failed - restart or manually set vim.g.hopcsharp_processing to false'

    if vim.g.hopcsharp_processing then
        vim.notify(message)
        return
    end

    return callback()
end

M.__log = function(message, prefix)
    prefix = prefix or 'hopcsharp: '
    print(M.__escape_ansi(prefix .. message))
end

---@param entries table to iterate on
---@param callback function will be called on each entry in entries via vim.schedule
M.__scheduled_iteration = function(entries, callback)
    if not entries then
        return
    end

    -- TODO cover with unittests
    local should_stop = false

    local function stop()
        should_stop = true
    end

    local function iterate(i)
        if i > #entries then
            -- finished iteration
            return
        end

        callback(i, entries[i], entries, stop)

        if not should_stop then
            vim.schedule(function()
                iterate(i + 1)
            end)
        end
    end

    iterate(1)
end

M.__escape_ansi = function(string)
    local result, _ = string
        :gsub('%^%[%[%?%d+%a', '') -- ^[[?131232h
        :gsub('%^%[%[%d+%a', '') -- ^[[123131H
        :gsub('%^%[%[%a', '') -- ^[[D
        :gsub('\27%[%?%d+%a', '') -- \27[?131232h
        :gsub('\27%[%d+%a', '') -- \27[123131H
        :gsub('\27%[%a', '') -- \27[D

    return result
end

return M
