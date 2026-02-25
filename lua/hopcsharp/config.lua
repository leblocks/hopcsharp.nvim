local M = {}

---@class HopcsharpUserConfigurationOverride
---@field jump_on_quickfix boolean If true, immediately jump to first quickfix entry when multiple results are found
---@field filter_entry_under_cursor boolean If true, exclude an entry at the current cursor position from results
---@field callback function Custom callback to handle results instead of using quickfix list, receives list of entries

---@class HopcsharpDatabaseConfiguration
---@field folder_path string Directory path where the SQLite database file is stored (default: vim.fn.stdpath('state'))
---@field buffer_size number Number of entries to buffer before flushing to the database during init

---@class HopcsharpHopConfiguration
---@field jump_on_quickfix boolean If true, immediately jump to first quickfix entry when multiple results are found
---@field filter_entry_under_cursor boolean If true, exclude an entry at the current cursor position from results

---@class HopcsharpConfiguration
---@field hop HopcsharpHopConfiguration Hop navigation settings
---@field database HopcsharpDatabaseConfiguration Database storage settings
local config = {

    hop = {
        jump_on_quickfix = false,
        filter_entry_under_cursor = true,
    },

    database = {
        folder_path = vim.fn.stdpath('state'),
        buffer_size = 10000,
    },
}

---@return HopcsharpConfiguration Table with hopcsharp configuration
M.__get_config = function()
    return config
end

-- TODO tests
---@param opts HopcsharpConfiguration Configuration object
M.__set_config = function(opts)
    local jump_on_quickfix = M.__get_value(opts, { 'hop', 'jump_on_quickfix' })
    if jump_on_quickfix ~= nil then
        config.hop.jump_on_quickfix = jump_on_quickfix
    end

    local filter_entry_under_cursor = M.__get_value(opts, { 'hop', 'filter_entry_under_cursor' })
    if filter_entry_under_cursor ~= nil then
        config.hop.filter_entry_under_cursor = filter_entry_under_cursor
    end

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
