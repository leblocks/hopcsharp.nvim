local dbutils = require('hopcsharp.database.utils')
local query = require('hopcsharp.parse.query')
local pautils = require('hopcsharp.parse.utils')

local M = {}

---@param tree TSNode under which the search will occur
---@param path_id number file path id
---@param namespace_id number namespace id
---@param file_content string file content
---@param writer BufferedWriter buffered database writer
M.__parse_reference = function(tree, path_id, namespace_id, file_content, writer)
    pautils.__icaptures(query.reference, tree, file_content, function(node, content)
        local parent_node_type = node:parent():type()

        -- should not be a problem with nulls
        -- those nodes are always inside other nodes
        if parent_node_type == 'generic_name' or parent_node_type == 'member_access_expression' then
            parent_node_type = node:parent():parent():type()
        end

        local type

        local row, column, _, _ = node:range()

        if parent_node_type == 'object_creation_expression' then
            type = dbutils.reference_types.OBJECT_CREATION
        elseif parent_node_type == 'invocation_expression' then
            type = dbutils.reference_types.METHOD_INVOCATION
        elseif parent_node_type == 'member_access_expression' then
            -- in context of a query that is being used,
            -- it must be a method invocation
            type = dbutils.reference_types.METHOD_INVOCATION
        elseif parent_node_type == 'attribute' then
            type = dbutils.reference_types.ATTRIBUTE
        elseif parent_node_type == 'variable_declaration' then
            type = dbutils.reference_types.VARIABLE_DECLARATION
        end

        writer:add_to_buffer('reference', {
            path_id = path_id,
            namespace_id = namespace_id,
            type = type,
            name = vim.treesitter.get_node_text(node, content, nil),
            row = row,
            column = column,
        })
    end)
end

return M
