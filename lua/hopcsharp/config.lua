local M = {}

---@class HopcsharpUserConfigurationOverride
---@field jump_on_quickfix boolean TODO doc
---@field filter_entry_under_cursor boolean TODO doc
---@field callback function TODO doc

---@class HopcsharpDatabaseConfiguration
---@field folder_path string TODO file path
---@field buffer_size number TODO buffer size

---@class HopcsharpHopConfiguration
---@field jump_on_quickfix boolean TODO doc
---@field filter_entry_under_cursor boolean TODO doc

---@class HopcsharpConfiguration
---@field hop HopcsharpHopConfiguration TODO doc
---@field database HopcsharpDatabaseConfiguration TODO doc
local config = {

    hop = {
        jump_on_quickfix = false,
        filter_entry_under_cursor = true,
    },

    database = {
        -- TODO rename to folder path
        folder_path = vim.fn.stdpath('state'),
        buffer_size = 10000,
    },
}

-- TODO tests
---@return HopcsharpConfiguration Table with hopcsharp configuration
M.__get_config = function()
    return config
end

-- TODO tests
---@param opts HopcsharpConfiguration Configuration object
M.__set_config = function(opts)
    config.hop.jump_on_quickfix = M.__get_value(opts, { 'hop', 'jump_on_quickfix' }) or config.hop.jump_on_quickfix

    config.hop.filter_entry_under_cursor = M.__get_value(opts, { 'hop', 'filter_entry_under_cursor' })
        or config.hop.filter_entry_under_cursor

    config.database.folder_path = M.__get_value(opts, { 'database', 'folder_path' }) or config.database.folder_path

    config.database.buffer_size = M.__get_value(opts, { 'database', 'buffer_size' }) or config.database.buffer_size
end

M.__get_value = function(object, path)
    if object == nil then
        return nil
    end

    -- go down the path level by level
    local level = object
    for _, path_element in ipairs(path) do
        if level[path_element] == nil then
            return nil
        end
        level = level[path_element]
    end

    -- we've got to the last level
    return level
end

return M
