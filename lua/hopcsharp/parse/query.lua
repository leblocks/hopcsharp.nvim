local utils = require('hopcsharp.parse.utils')

local M = {}

M.namespace = utils.__get_query([[
    [
        (namespace_declaration (qualified_name) @name)
        (file_scoped_namespace_declaration (qualified_name) @name)
    ]
]])

M.declaration_identifier = utils.__get_query([[
    [
        (enum_declaration name: (identifier) @name)
        (class_declaration name: (identifier) @name)
        (struct_declaration name: (identifier) @name)
        (record_declaration name: (identifier) @name)
        (method_declaration name: (identifier) @name)
        (interface_declaration name: (identifier) @name)
        (constructor_declaration name: (identifier) @name)
    ]
]])

return M
