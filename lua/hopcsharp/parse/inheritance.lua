local query = require('hopcsharp.parse.query')

local M = {}

---@param tree TSNode under which the search will occur
---@param file_content string file content
---@param writer BufferedWriter buffered database writer
M.__parse_inheritance = function(tree, _, file_content, writer)
    for _, match, _ in query.base_identifier:iter_matches(tree, file_content, 0, -1) do
        local entry = {}
        for id, nodes in pairs(match) do
            local name = query.base_identifier.captures[id]
            for _, node in ipairs(nodes) do
                entry[name] = vim.treesitter.get_node_text(node, file_content, nil)
            end
        end
        writer:add_to_buffer('inheritance', entry)
    end
end

return M
