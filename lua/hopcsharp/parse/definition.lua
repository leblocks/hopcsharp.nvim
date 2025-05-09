local pautils = require('hopcsharp.parse.utils')
local dbutils = require('hopcsharp.database.utils')
local query = require('hopcsharp.parse.query')

local M = {}

---@param tree TSNode under which the search will occur
---@param file_path string file path
---@param file_content string file content
---@param db sqlite_db db object
M.__parse_definitions = function(tree, file_path, file_content, db)
    local namespace_id = nil
    local path_id = pautils.__insert_file(db, file_path)

    pautils.__icaptures(query.namespace, tree, file_content, function(node, content)
        local name = vim.treesitter.get_node_text(node, content, nil)
        namespace_id = pautils.__insert_namespace(db, name)
    end)

    pautils.__icaptures(query.declaration_identifier, tree, file_content, function(node, content)
        local parent_node_type = node:parent():type()
        local type

        if parent_node_type == 'class_declaration' then
            type = dbutils.__types.CLASS
        elseif parent_node_type == 'enum_declaration' then
            type = dbutils.__types.ENUM
        elseif parent_node_type == 'struct_declaration' then
            type = dbutils.__types.STRUCT
        elseif parent_node_type == 'record_declaration' then
            type = dbutils.__types.RECORD
        elseif parent_node_type == 'method_declaration' then
            type = dbutils.__types.METHOD
        elseif parent_node_type == 'interface_declaration' then
            type = dbutils.__types.INTERFACE
        elseif parent_node_type == 'constructor_declaration' then
            type = dbutils.__types.CONSTRUCTOR
        end

        local row, column, _, _ = node:range()

        db:insert('definitions', {
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
