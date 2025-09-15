local utils = require('hopcsharp.utils')
local query = require('hopcsharp.parse.query')
local pautils = require('hopcsharp.parse.utils')

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

                local type_parameter = ''
                pautils.__icaptures(query.type_parameter_list, node:parent(), file_content, function(n, c)
                    -- remove spaces, so <T, V> will be treated the same as <T,V>
                    type_parameter = utils.__trim_spaces(vim.treesitter.get_node_text(n, c, nil))
                end)

                entry[name] = vim.treesitter.get_node_text(node, file_content, nil) .. type_parameter
            end
        end
        writer:add_to_buffer('inheritance', entry)
    end
end

return M
