local query = require('hopcsharp.parse.query')
local pautils = require('hopcsharp.parse.utils')

local M = {}

---@param tree TSNode under which the search will occur
---@param path_id number file path id
---@param file_content string file content
---@param writer BufferedWriter buffered database writer
M.__parse_usings = function(tree, path_id, file_content, writer)
    pautils.__icaptures(query.using_identifier, tree, file_content, function(node, content)
        writer:add_to_buffer('usings', {
            path_id = path_id,
            namespace = vim.treesitter.get_node_text(node, content, nil),
        })
    end)
end

return M
