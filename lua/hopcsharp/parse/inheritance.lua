local utils = require('hopcsharp.utils')
local query = require('hopcsharp.parse.query')

local M = {}

---@param tree TSNode under which the search will occur
---@param path_id number file path id
---@param namespace_id number namespace id
---@param file_content string file content
---@param writer BufferedWriter buffered database writer
M.__parse_inheritance = function(tree, path_id, namespace_id, file_content, writer)
    for _, match, _ in query.base_identifier:iter_matches(tree, file_content, 0, -1) do
        local entry = {
            path_id = path_id,
            namespace_id = namespace_id,
        }

        for id, nodes in pairs(match) do
            local name = query.base_identifier.captures[id]
            for _, node in ipairs(nodes) do
                local type_parameter = ''

                local sibling = node:next_sibling()
                if sibling ~= nil and sibling:type() == 'type_parameter_list' then
                    type_parameter = utils.__trim_spaces(vim.treesitter.get_node_text(sibling, file_content))
                end

                entry[name] = vim.treesitter.get_node_text(node, file_content, nil) .. type_parameter
            end
        end
        writer:add_to_buffer('inheritance', entry)
    end
end

return M
