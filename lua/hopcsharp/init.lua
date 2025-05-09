local parse = require('hopcsharp.parse')
local definition = require('hopcsharp.parse.definition')

local hop = require('hopcsharp.hop')
local database = require('hopcsharp.database')

local M = {}

vim.g.hopcsharp_processing = false

local function log(message)
    vim.notify('hopscsharp: ' .. message, vim.log.levels.INFO)
end

local function throw_on_processing()
    if vim.g.hopcsharp_processing then
        error('init_database is running, try again later. If init_database failed - restart or manually set vim.g.hopcsharp_processing to false')
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
    throw_on_processing()

    vim.g.hopcsharp_processing = true

    -- drop existing schema
    database.__drop_db()

    -- get files to process and calculate progress
    local files = parse.__get_source_files()
    local percent_step = 5
    local step = #files / (100 / percent_step)
    local total_percent_progress = 0
    local counter = 0;

    log('found ' .. #files .. ' files to process')

    scheduled_iteration(1, files, function(i, items)
        parse.__parse_tree(items[i], function(tree, file_path, file_content, db)
            definition.__parse_definitions(tree:root(), file_path, file_content, db)
        end)

        counter = counter + 1

        if counter >= step then
            counter = 0
            total_percent_progress = total_percent_progress + percent_step
            log('processed ' .. total_percent_progress .. '% of source files')
        end

        if i == #items then
            vim.g.hopcsharp_processing = false
            log('finished processing source files')
        end
    end)
end

M.hop_to_definition = function(callback)
    throw_on_processing()
    hop.__hop_to_definition(callback)
end

---@return sqlite_db
M.get_db = function()
    throw_on_processing()
    return database.__get_db()
end

return M
