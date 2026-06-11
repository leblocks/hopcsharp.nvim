local debug = require('hopcsharp.debug')

local M = {}

---@param query string
---@return vim.treesitter.Query
M.__get_query = function(query)
    local ok, result = pcall(vim.treesitter.query.parse, 'c_sharp', query)

    if ok then
        return result
    end

    debug.__log_error('treesitter c_sharp parser is not found')

    return nil
end

---@param query vim.treesitter.Query
---@param tree TSNode
---@param file_content string
---@param callback function
M.__icaptures = function(query, tree, file_content, callback)
    for _, node, _, _ in query:iter_captures(tree, file_content, 0, -1) do
        callback(node, file_content)
    end
end

return M
