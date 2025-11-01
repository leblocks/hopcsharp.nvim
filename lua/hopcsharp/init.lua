local os = require('os')

local parse = require('hopcsharp.parse')
local utils = require('hopcsharp.utils')
local definition = require('hopcsharp.parse.definition')
local inheritance = require('hopcsharp.parse.inheritance')
local reference = require('hopcsharp.parse.reference')

local hop = require('hopcsharp.hop')
local hierarchy = require('hopcsharp.hierarchy')
local database = require('hopcsharp.database')
local BufferedWriter = require('hopcsharp.database.buffer')

local M = {}

vim.g.hopcsharp_processing = false

M.__init_database = function()
    -- drop existing schema
    database.__drop_db()
    local writer = BufferedWriter:new(database.__get_db(), 1000)

    local files = parse.__get_source_files()

    local counter = 0

    utils.__scheduled_iteration(files, function(i, item, items)
        parse.__parse_tree(item, function(tree, file_path_id, file_content, wr)
            local root = tree:root()
            definition.__parse_definitions(root, file_path_id, file_content, wr)
            inheritance.__parse_inheritance(root, file_path_id, file_content, wr)
            reference.__parse_reference(root, file_path_id, file_content, wr)
        end, writer)

        counter = counter + 1

        if counter % 100 == 0 then
            utils.__log(string.format('processed %s/%s of files', counter, #items), '')
        end

        if counter == #items then
            writer:flush()
        end
    end)
end

M.init_database = function()
    utils.__block_on_processing(function()
        vim.g.hopcsharp_processing = true

        local command = {
            'nvim',
            '--headless',
            '-c',
            'lua require("hopcsharp").__init_database()',
            '-c',
            'qa',
        }

        local line_buffer = {}
        -- using table here, for quirks of different OS's
        -- to add different line separators
        local line_separators = { '\r\r', '\r' }

        local function flush_line_buffer()
            if #line_buffer > 0 then
                utils.__log(table.concat(line_buffer, ''))
                line_buffer = {}
            end
        end

        local start = os.time()
        local on_stdout = function(_, data)
            for _, entry in ipairs(data) do
                if utils.__contains(line_separators, entry) then
                    flush_line_buffer()
                else
                    table.insert(line_buffer, entry)
                end
            end
        end

        local on_exit = function(_)
            flush_line_buffer()
            vim.g.hopcsharp_processing = false
            local elapsed = os.difftime(os.time(), start)
            utils.__log('finished processing files ' .. elapsed .. 's elapsed')
        end

        -- spawn actual parsing in a separate instance of neovim
        vim.fn.jobstart(command, {
            cwd = vim.fn.getcwd(),
            on_stdout = on_stdout,
            on_exit = on_exit,
            pty = true,
            stdin = nil,
        })
    end)
end

M.hop_to_definition = function(config)
    utils.__block_on_processing(function()
        hop.__hop_to_definition(config)
    end)
end

M.hop_to_implementation = function(config)
    utils.__block_on_processing(function()
        hop.__hop_to_implementation(config)
    end)
end

-- TODO documentation
M.hop_to_reference = function(config)
    utils.__block_on_processing(function()
        hop.__hop_to_reference(config)
    end)
end

M.get_type_hierarchy = function()
    utils.__block_on_processing(function()
        hierarchy.__get_type_hierarchy()
    end)
end

---@return sqlite_db
M.get_db = function()
    return utils.__block_on_processing(function()
        return database.__get_db()
    end)
end

return M
