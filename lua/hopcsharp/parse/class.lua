local pautils = require('hopcsharp.parse.utils')
local dbutils = require('hopcsharp.database.utils')
local query = require('hopcsharp.parse.query')

local M = {}

---@param tree TSNode under which the search will occur
---@param file_path string file path
---@param file_content string file content
---@param db sqlite_db db object
M.__parse_classes = function(tree, file_path, file_content, db)
    local namespace_id = nil
    local path_id = pautils.__insert_file(db, file_path)

    pautils.__icaptures(query.namespace, tree, file_content, function(node, content)
        local name = vim.treesitter.get_node_text(node, content, nil)
        namespace_id = pautils.__insert_namespace(db, name)
    end)

    pautils.__icaptures(query.class_declaration, tree, file_content, function(node, content)
        local class_id
        pautils.__icaptures(query.class_identifier, node, content, function(n, c)
            local row, col, _, _ = n:range()
            local name = vim.treesitter.get_node_text(n, c, nil)
            class_id = dbutils.__insert_object(db, path_id, namespace_id, dbutils.__types.CLASS, name, row, col)
        end)

        pautils.__icaptures(query.method_declaration, node, content, function(n, c)
            pautils.__icaptures(query.method_identifier, n, c, function(nn, cc)
                local start_row, start_column, _, _ = nn:range()
                db:insert('methods', {
                    parent_id = class_id,
                    type = dbutils.__types.METHOD,
                    name = vim.treesitter.get_node_text(nn, cc, nil),
                    row = start_row,
                    column = start_column,
                })
            end)
        end)
    end)
end


return M
