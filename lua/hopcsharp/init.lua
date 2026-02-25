local os = require('os')

local parse = require('hopcsharp.parse')
local utils = require('hopcsharp.utils')
local config = require('hopcsharp.config')

local hop = require('hopcsharp.hop')
local hierarchy = require('hopcsharp.hierarchy')
local database = require('hopcsharp.database')
local BufferedWriter = require('hopcsharp.database.buffer')

local M = {}

vim.g.hopcsharp_processing = false

M.__init_database = function()
    -- drop existing schema
    database.__drop_db()
    local buffer_size = config.__get_config().database.buffer_size
    local writer = BufferedWriter:new(database.__get_db(), buffer_size)

    local files = parse.__get_source_files()

    local counter = 0

    utils.__scheduled_iteration(files, function(_, item, items)
        parse.__parse_file(item, writer)
        counter = counter + 1

        if counter % 100 == 0 then
            utils.__log(string.format('processed %s/%s of files', counter, #items), '')
        end

        if counter == #items then
            writer:flush()
            utils.__log('creating indexes', '')
            database.__create_indexes()
        end
    end)
end

---@param opts HopcsharpConfiguration Configuration object
M.setup = function(opts)
    -- TODO
    -- vimdoc
    -- usage in methods
    config.__set_config(opts)
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

M.hop_to_definition = function(config_override)
    utils.__block_on_processing(function()
        hop.__hop_to_definition(config_override)
    end)
end

M.hop_to_implementation = function(config_override)
    utils.__block_on_processing(function()
        hop.__hop_to_implementation(config_override)
    end)
end

M.hop_to_reference = function(config_override)
    utils.__block_on_processing(function()
        hop.__hop_to_reference(config_override)
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
