local database = require('hopcsharp.database')
local query = require('hopcsharp.parse.query')

local M = {}

local EMPTY_NAMESPACE_NAME = 'n\\a'

---@param tree TSNode under which the search will occur
---@param file_content string file content
M.__parse_namespaces = function(tree, file_content)
    local db = database.__get_db()

    -- add empty namespace
    local empty_namespace_id = M.__insert_empty_namespace(db)

    for _, node, _, _ in query.namespace_identifier:iter_captures(tree, file_content, 0, -1) do
        local namespace = vim.treesitter.get_node_text(node, file_content, nil)

        local entries = db:select('namespaces', { where = { name = namespace } })

        if #entries == 0 then
            -- insert new namespace
            local _, id = db:insert('namespaces', { name = namespace })
            return id
        else
            return entries[1].id
        end
    end

    -- every file must have a namespace defined
    -- in a rare case when it is missing
    return empty_namespace_id
end

M.__insert_empty_namespace = function(db)
    local entries = db:select('namespaces', { where = { name = EMPTY_NAMESPACE_NAME } })

    if #entries == 0 then
        -- insert new namespace
        local _, id = db:insert('namespaces', { name = EMPTY_NAMESPACE_NAME })
        return id
    else
        return entries[1].id
    end
end

return M
