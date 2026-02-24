local db_utils = require('hopcsharp.database.utils')

local M = {}

---@class HopcsharpHopConfiguration
---@field jump_on_quickfix TODO doc

---@class HopcsharpDatabaseConfiguration
---@field file_path string TODO file path
---@field buffer_size number TODO buffer size

---@class HopcsharpConfiguration
---@field hop HopcsharpHopConfiguration TODO doc
---@field database HopcsharpDatabaseConfiguration TODO doc
local config = {

    hop = {
        jump_on_quickfix = false,
    },

    database = {
        file_path = vim.fs.joinpath(vim.fn.stdpath('state'), db_utils.__get_db_file_name(vim.fn.getcwd())),
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
    config.database.file_path = M.__get_value(opts, { 'database', 'file_path' }) or config.database.file_path
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
