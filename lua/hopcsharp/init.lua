local os = require('os')

local parse = require('hopcsharp.parse')
local definition = require('hopcsharp.parse.definition')
local inheritance = require('hopcsharp.parse.inheritance')

local hop = require('hopcsharp.hop')
local hierarchy = require('hopcsharp.hierarchy')
local database = require('hopcsharp.database')
local BufferedWriter = require('hopcsharp.database.buffer')

local M = {}

local PROCESSING_ERROR_MESSAGE = 'init_database is running, try again later. '
    .. 'If init_database failed - restart or manually set vim.g.hopcsharp_processing to false'

vim.g.hopcsharp_processing = false

local function log(message)
    print(message)
end

local function scheduled_iteration(i, iterable, callback)
    if i > #iterable then
        return
    end

    callback(i, iterable)

    vim.schedule(function()
        scheduled_iteration(i + 1, iterable, callback)
    end)
end

M.__init_database = function()
    -- drop existing schema
    database.__drop_db()
    local writer = BufferedWriter:new(database.__get_db(), 1000)

    local counter = 0
    scheduled_iteration(1, parse.__get_source_files(), function(i, items)
        parse.__parse_tree(items[i], function(tree, file_path_id, file_content, wr)
            local root = tree:root()
            definition.__parse_definitions(root, file_path_id, file_content, wr)
            inheritance.__parse_inheritance(root, file_path_id, file_content, wr)
        end, writer)

        counter = counter + 1

        if counter % 100 == 0 then
            log(string.format('processed %s/%s of files', counter, #items))
        end

        if counter == #items then
            writer:flush()
        end
    end)
end

M.init_database = function()
    if vim.g.hopcsharp_processing then
        vim.notify(PROCESSING_ERROR_MESSAGE)
        return
    end

    vim.g.hopcsharp_processing = true

    local command = {
        'nvim',
        '--headless',
        '-c',
        'lua require("hopcsharp").__init_database()',
        '-c',
        'qa',
    }

    local start = os.time()
    local on_stdout = function(_, data)
        if #data > 0 then
            print('hopcsharp: ' .. table.concat(data, ''))
        end
    end

    local on_exit = function(_)
        vim.g.hopcsharp_processing = false
        local elapsed = os.difftime(os.time(), start)
        print('hopcsharp: finished processing files ' .. elapsed .. 's elapsed')
    end

    -- spawn actual parsing in a separate instance of neovim
    vim.fn.jobstart(command, {
        cwd = vim.fn.getcwd(),
        on_stdout = on_stdout,
        on_exit = on_exit,
        pty = true,
        stdin = nil,
    })
end

M.hop_to_definition = function(config)
    if vim.g.hopcsharp_processing then
        vim.notify(PROCESSING_ERROR_MESSAGE)
        return
    end
    hop.__hop_to_definition(config)
end

M.hop_to_implementation = function(config)
    if vim.g.hopcsharp_processing then
        vim.notify(PROCESSING_ERROR_MESSAGE)
        return
    end
    hop.__hop_to_implementation(config)
end

M.get_type_hierarchy = function()
    if vim.g.hopcsharp_processing then
        vim.notify(PROCESSING_ERROR_MESSAGE)
        return
    end
    hierarchy.__get_type_hierarchy()
end

---@return sqlite_db
M.get_db = function()
    if vim.g.hopcsharp_processing then
        vim.notify(PROCESSING_ERROR_MESSAGE)
        return
    end
    return database.__get_db()
end

return M
