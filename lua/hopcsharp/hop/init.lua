local utils = require('hopcsharp.utils')
local hop_utils = require('hopcsharp.hop.utils')
local dbutils = require('hopcsharp.database.utils')

local definition_providers = require('hopcsharp.hop.providers.definition')
local reference_providers = require('hopcsharp.hop.providers.reference')
local implementation_providers = require('hopcsharp.hop.providers.implementation')

local M = {}

local stop_callback = nil

local function populate_quickfix(entries, jump_on_quickfix, type_converter)
    -- stop previous quickfix population
    -- won't work 100% but it much better
    -- rathen that nothing
    if stop_callback then
        stop_callback()
        stop_callback = nil
    end

    -- remove previous quickfix entries
    vim.fn.setqflist({}, 'r')

    utils.__scheduled_iteration(entries, function(i, item, _, stop)
        if i == 1 then
            stop_callback = stop
        end

        vim.fn.setqflist(
            {
                {
                    filename = item.path,
                    lnum = item.row + 1,
                    col = item.col,
                    text = string.format('%-20s | %s', type_converter(item.type), item.namespace or ''),
                },
            },
            'a'
        )
    end)

    vim.cmd([[ :copen ]])

    if jump_on_quickfix then
        vim.cmd([[ :cc! ]])
    end
end

local function filter_entry_under_cursor(entries)
    local filtered_entries = {}
    local current_line = vim.fn.getcurpos()[2] -- 2 for line number
    local current_file = vim.fs.normalize(vim.fn.expand('%:p'))
    for _, entry in ipairs(entries) do
        if (entry.row + 1) == current_line then
            local full_path = vim.fs.joinpath(vim.fn.getcwd(), entry.path)
            if current_file == full_path then
                goto continue
            end
        end
        table.insert(filtered_entries, entry)
        ::continue::
    end

    return filtered_entries
end

---@param hop_providers HopProvider[] Hop providers, those define where to jump
---@param config table User configuration
M.__hop_to = function(hop_providers, config)
    config = config or {}
    local callback = config.callback or nil
    local jump_on_quickfix = config.jump_on_quickfix or false

    for _, provider in ipairs(hop_providers) do
        if provider.can_handle() then
            local items, type_converter = provider.get_hops()

            -- if current provider didn't find anything
            -- try next one :D
            if type(items) == 'table' then
                -- filter out current position
                local filtered_items = filter_entry_under_cursor(items)

                if #filtered_items == 0 then
                    return
                end

                if callback ~= nil then
                    -- user provided custom logic for navigation
                    -- execute and return
                    callback(filtered_items)
                    return
                end

                -- immediate jump if there is only one case
                if #filtered_items == 1 then
                    hop_utils.__hop(filtered_items[1].path, filtered_items[1].row + 1, filtered_items[1].column)
                    return
                end

                -- sent to quickfix if there is too much
                if #filtered_items > 1 then
                    -- TODO cover this in test
                    local converter = type_converter or dbutils.get_type_name
                    populate_quickfix(filtered_items, jump_on_quickfix, converter)
                end

                return
            end
        end
    end
end

M.__hop_to_definition = function(config)
    local cword = vim.fn.expand('<cword>')
    local node = vim.treesitter.get_node()
    M.__hop_to({
        definition_providers.__by_name_and_used_namespaces(cword, node),
        definition_providers.__by_name_and_type(cword, node),
        definition_providers.__by_name(cword, node),
    }, config)
end

M.__hop_to_implementation = function(config)
    local cword = vim.fn.expand('<cword>')
    local node = vim.treesitter.get_node()
    M.__hop_to({
        implementation_providers.__by_parent_name_and_method_name(cword, node),
        implementation_providers.__by_name(cword, node),
    }, config)
end

M.__hop_to_reference = function(config)
    local cword = vim.fn.expand('<cword>')
    local node = vim.treesitter.get_node()
    M.__hop_to({
        reference_providers.__by_name(cword, node),
    }, config)
end

return M
