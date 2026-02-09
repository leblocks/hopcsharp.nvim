local hop_utils = require('hopcsharp.hop.utils')
local db_utils = require('hopcsharp.database.utils')

local M = {}

local function parse_entry(entry, items)
    local id = nil

    -- lookup id of the item in items
    for part in string.gmatch(entry, '%[(%d+)%]') do
        id = tonumber(part)
    end

    local item = items[id]

    return item.path, item.row, item.column, item.type, item.namespace
end

M.__format_entry_name_type_namespace = function(i, entry)
    local type_name = db_utils.get_type_name(entry.type)
    return string.format('%-50s %-20s %-30s [%s]', entry.name, type_name, entry.namespace, i)
end

M.__format_name_and_namespace = function(i, entry)
    return string.format('%-70s %-30s [%s]', entry.name, entry.namespace, i)
end

M.__get_picker = function(fzf, builtin_previewer, items_provider, formatter)
    -- store items in a closure
    -- so after db call and render
    -- we can retrieve info from here
    local items = {}

    -- see example here https://github.com/ibhagwan/fzf-lua/wiki/Advanced#preview-nvim-builtin
    local custom_previewer = builtin_previewer.buffer_or_file:extend()

    function custom_previewer:new(o, opts, fzf_win)
        custom_previewer.super.new(self, o, opts, fzf_win)
        setmetatable(self, custom_previewer)
        return self
    end

    function custom_previewer:parse_entry(entry_str)
        local path, line, col = parse_entry(entry_str, items)
        return { path = path, line = line + 1, col = col + 1 }
    end

    local picker = function()
        -- get database (connection is always opened)
        fzf.fzf_exec(function(fzf_cb)
            coroutine.wrap(function()
                local co = coroutine.running()
                items = items_provider()

                if type(items) ~= 'table' then
                    items = {}
                end

                for i, entry in ipairs(items) do
                    fzf_cb(formatter(i, entry), function()
                        coroutine.resume(co)
                    end)
                    coroutine.yield()
                end
                fzf_cb()
            end)()
        end, {
            actions = {
                -- on select hop to definition by path row and column
                ['default'] = function(selected)
                    local path, row, column = parse_entry(selected[1], items)
                    hop_utils.__hop(path, row, column)
                end,

                ['ctrl-v'] = function(selected)
                    local path, row, column = parse_entry(selected[1], items)
                    hop_utils.__vhop(path, row, column)
                end,

                ['ctrl-s'] = function(selected)
                    local path, row, column = parse_entry(selected[1], items)
                    hop_utils.__shop(path, row, column)
                end,

                ['ctrl-t'] = function(selected)
                    local path, row, column = parse_entry(selected[1], items)
                    hop_utils.__thop(path, row, column)
                end,

                ['alt-q'] = function(selected)
                    local quickfix_entries = {}
                    for _, selected_item in ipairs(selected) do
                        local path, row, column, type, namespace = parse_entry(selected_item, items)
                        table.insert(quickfix_entries, {
                            path = path,
                            row = row,
                            column = column,
                            type = type,
                            namespace = namespace,
                        })
                    end

                    hop_utils.__populate_quickfix(quickfix_entries, true, db_utils.get_type_name)
                end,
            },

            previewer = custom_previewer,

            fzf_opts = {
                ['--wrap'] = false,
                ['--multi'] = true,
            },
        })
    end
    return picker
end

return M
