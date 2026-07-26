local config = require('hopcsharp.config')
local debug = require('hopcsharp.debug')
local hop_utils = require('hopcsharp.hop.utils')
local dbutils = require('hopcsharp.database.utils')

local definition_providers = require('hopcsharp.hop.providers.definition')
local reference_providers = require('hopcsharp.hop.providers.reference')
local implementation_providers = require('hopcsharp.hop.providers.implementation')

local M = {}

local log_hop_to_x = function(method, cword, node, config_override)
    debug.__log_debug(method .. ' <cword> ' .. cword)

    if node then
        debug.__log_debug(method .. ' node ' .. node:type())
    end

    debug.__log_debug(method .. ' config_override ' .. vim.inspect(config_override))
end

local log_hop_to = function(i, message)
    debug.__log_debug('__hop_to(' .. i .. ') ' .. message)
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
---@param config_override HopcsharpUserConfigurationOverride User provided configuration overrides
M.__hop_to = function(hop_providers, config_override)
    local current_config = config.__get_config()
    config_override = config_override or {}
    local callback = config_override.callback or nil
    local jump_on_quickfix = config_override.jump_on_quickfix or current_config.hop.jump_on_quickfix

    local filter_under_cursor = config_override.filter_entry_under_cursor
        or current_config.hop.filter_entry_under_cursor

    for i, provider in ipairs(hop_providers) do
        log_hop_to(i, 'trying')
        if provider.can_handle() then
            log_hop_to(i, 'can_handle() = true')
            local items, type_converter = provider.get_hops()

            -- if current provider didn't find anything
            -- try next one :D
            if type(items) == 'table' then
                log_hop_to(i, '#items = ' .. #items)
                -- filter out current position if requested
                local filtered_items
                if filter_under_cursor then
                    filtered_items = filter_entry_under_cursor(items)
                else
                    filtered_items = items
                end

                if #filtered_items == 0 then
                    log_hop_to(i, '#filtered_items = ' .. #filtered_items)
                    return
                end

                if callback ~= nil then
                    log_hop_to(i, 'using callback')
                    -- user provided custom logic for navigation
                    -- execute and return
                    callback(filtered_items)
                    return
                end

                -- immediate jump if there is only one case
                if #filtered_items == 1 then
                    log_hop_to(i, 'immediate jump instead of quickfix')
                    hop_utils.__hop(filtered_items[1].path, filtered_items[1].row + 1, filtered_items[1].column)
                    return
                end

                -- sent to quickfix if there is too much
                if #filtered_items > 1 then
                    log_hop_to(i, 'send to quick fix')
                    local converter = type_converter or dbutils.get_type_name
                    hop_utils.__populate_quickfix(filtered_items, jump_on_quickfix, converter)
                end

                return
            end
        end
    end
end

M.__hop_to_definition = function(config_override)
    local cword = vim.fn.expand('<cword>')
    local node = vim.treesitter.get_node()
    log_hop_to_x('__hop_to_definition', cword, node, config_override)
    M.__hop_to({
        definition_providers.__by_name_type_and_current_namespace(cword, node),
        definition_providers.__by_name_type_and_used_namespaces(cword, node),
        definition_providers.__by_name_and_type(cword, node),
        definition_providers.__by_name(cword, node),
    }, config_override)
end

M.__hop_to_implementation = function(config_override)
    local cword = vim.fn.expand('<cword>')
    local node = vim.treesitter.get_node()
    log_hop_to_x('__hop_to_implementation', cword, node, config_override)
    M.__hop_to({
        implementation_providers.__by_parent_name_and_method_name(cword, node),
        implementation_providers.__by_name(cword, node),
    }, config_override)
end

M.__hop_to_reference = function(config_override)
    local cword = vim.fn.expand('<cword>')
    local node = vim.treesitter.get_node()
    log_hop_to_x('__hop_to_reference', cword, node, config_override)
    M.__hop_to({
        reference_providers.__by_name_and_current_namespace(cword, node),
        reference_providers.__by_name(cword, node),
    }, config_override)
end

return M
