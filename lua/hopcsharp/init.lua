local parse = require('hopcsharp.parse')
local database = require('hopcsharp.db')

local M = {}

local function log(message)
    print('hopcsharp: ' .. message)
end

local is_processing = false

M.init_database = function()
    if is_processing then
        return
    end

    is_processing = true

    -- drop existing schema
    local db = database.__get_db()
    db:with_open(function()
        db:eval("delete from classes")
        db:eval("delete from namespaces")
        db:eval("delete from files")
        db:eval("vacuum")
    end)

    -- get files to process and calculate progress
    local files = parse.__get_source_files()
    local percent_step = 5
    local step = #files / (100 / percent_step)
    local total_percent_progress = 0
    local counter = 0;

    log('found ' .. #files .. ' files to process')
    for i, file in ipairs(files) do
        parse.__parse_tree(file, function(tree, file_path, file_content, db)
            parse.__parse_classes(tree:root(), file_path, file_content, db)
        end)

        counter = counter + 1

        if counter >= step then
            counter = 0
            total_percent_progress = total_percent_progress + percent_step
            log('processed ' .. total_percent_progress .. '% of source files')
        end

        if i == #files then
            is_processing = false
            log('finished processing source files')
        end
    end
end

M.goto_definition = function()
    if is_processing then
        return
    end
end

M.goto_reference = function()
    if is_processing then
        return
    end
end

--- TODO docs
---@return sqlite_db
M.get_code_db = function()
    if is_processing then
        return
    end
    return database.__get_db()
end

return M
