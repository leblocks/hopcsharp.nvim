local query = require('hopcsharp.parse.query')
local parse_utils = require('hopcsharp.parse.utils')
local database_utils = require('hopcsharp.database.utils')

local M = {}

---@param tree TSNode under which the search will occur
---@param path_id number file path id
---@param namespace_id number namespace id
---@param file_content string file content
---@param writer BufferedWriter buffered database writer
M.__parse_type_arguments = function(tree, path_id, namespace_id, file_content, writer)
    parse_utils.__icaptures(query.type_argument_list, tree, file_content, function(node, content)
        local row, column, _, _ = node:range()

        writer:add_to_buffer('reference', {
            path_id = path_id,
            namespace_id = namespace_id,
            type = database_utils.reference_types.TYPE_ARGUMENT,
            name = vim.treesitter.get_node_text(node, content, nil),
            row = row,
            column = column,
        })
    end)
end

return M
