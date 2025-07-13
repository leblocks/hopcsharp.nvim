local pautils = require('hopcsharp.parse.utils')
local dbutils = require('hopcsharp.database.utils')
local query = require('hopcsharp.parse.query')

local M = {}

---@param tree TSNode under which the search will occur
---@param path_id number file path id
---@param file_content string file content
---@param writer BufferedWriter buffered database writer
M.__parse_definitions = function(tree, path_id, file_content, writer)
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

        writer:add_to_buffer('definitions', {
            path_id = path_id,
            type = type,
            name = vim.treesitter.get_node_text(node, content, nil),
            row = row,
            column = column,
        })
    end)
end

return M
