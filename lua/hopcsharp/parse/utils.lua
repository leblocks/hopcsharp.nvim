local utils = require('hopcsharp.database.utils')

local M = {}

---@param query string
---@return vim.treesitter.Query
M.__get_query = function(query)
    return vim.treesitter.query.parse('c_sharp', query)
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

---@return integer namespace id
M.__insert_namespace = function(db, name)
    return utils.__insert_unique(db, 'namespaces', { name = name })
end

---@return integer file id
M.__insert_file = function(db, path)
    return utils.__insert_unique(db, 'files', { path = path })
end

return M
