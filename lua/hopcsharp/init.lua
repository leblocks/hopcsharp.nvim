local parse = require('hopcsharp.parse')
local database = require('hopcsharp.database')

local M = {}

local function log(message)
    vim.notify('hopscsharp: ' .. message, vim.log.levels.INFO)
end

local hopcsharp_is_processing = false

local function check_init_database_is_running()
    if hopcsharp_is_processing then
        error('init_database is running')
    end
end

local function scheduled_iteration(i, iterable, callback)
    if i > #iterable then
        return
    end

    callback(i, iterable)

    vim.schedule(function() scheduled_iteration(i + 1, iterable, callback) end)
end

M.init_database = function()
    check_init_database_is_running()

    hopcsharp_is_processing = true

    -- drop existing schema
    local db = database.__get_db()
    db:eval("delete from classes")
    db:eval("delete from namespaces")
    db:eval("delete from files")
    db:eval("vacuum")

    -- get files to process and calculate progress
    local files = parse.__get_source_files()
    local percent_step = 5
    local step = #files / (100 / percent_step)
    local total_percent_progress = 0
    local counter = 0;

    log('found ' .. #files .. ' files to process')

    scheduled_iteration(1, files, function(i, items)
        parse.__parse_tree(items[i], function(tree, file_path, file_content, db)
            parse.__parse_classes(tree:root(), file_path, file_content, db)
        end)

        counter = counter + 1

        if counter >= step then
            counter = 0
            total_percent_progress = total_percent_progress + percent_step
            log('processed ' .. total_percent_progress .. '% of source files')
        end

        if i == #items then
            hopcsharp_is_processing = false
            log('finished processing source files')
        end
    end)
end

M.goto_definition = function()
    check_init_database_is_running()
end

---@return sqlite_db
M.get_code_db = function()
    check_init_database_is_running()
    return database.__get_db()
end

return M
