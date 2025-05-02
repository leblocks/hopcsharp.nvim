local utils = require('hopcsharp.parse.utils')
local query = require('hopcsharp.parse.query')

local M = {}

---@param tree TSNode under which the search will occur
---@param file_path string file path
---@param file_content string file content
---@param db sqlite_db db object
M.__parse_classes = function(tree, file_path, file_content, db)
    local namespace_id = nil
    local file_path_id = utils.insert_file(db, file_path)

    utils.icaptures(query.namespace, tree, file_content, function(node, content)
        local name = vim.treesitter.get_node_text(node, content, nil)
        namespace_id = utils.insert_namespace(db, name)
    end)

    utils.icaptures(query.class_declaration, tree, file_content, function(node, content)
        utils.icaptures(query.class_identifier, node, content, function(n, c)
            local start_row, start_column, _, _ = n:range()
            db:insert('classes', {
                file_path_id = file_path_id,
                namespace_id = namespace_id,
                name = vim.treesitter.get_node_text(n, c, nil),
                row = start_row,
                column = start_column,
            })
        end)
    end)
end


return M
