local database = require('hopcsharp.database')
local pautils = require('hopcsharp.parse.utils')
local query = require('hopcsharp.parse.query')

local M = {}

---@param tree TSNode under which the search will occur
---@param file_content string file content
M.__parse_namespaces = function(tree, file_content)
    pautils.__icaptures(query.namespace_identifier, tree, file_content, function(node, content)

        local db = database.__get_db()
        local namespace = vim.treesitter.get_node_text(node, content, nil)

        local entries = db:select('namespaces', { where = { name = namespace } })

        if #entries == 0 then
            -- insert new namespace
            local _, id = db:insert('namespaces', { name = namespace })
            return id
        end
    end)
end

return M
