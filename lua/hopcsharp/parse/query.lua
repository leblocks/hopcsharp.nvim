local utils = require('hopcsharp.parse.utils')

local M = {}

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

M.base_identifier = utils.__get_query([[
    [
        (class_declaration name: (identifier) @name (base_list (identifier) @base))
        (struct_declaration name: (identifier) @name (base_list (identifier) @base))
        (record_declaration name: (identifier) @name (base_list (identifier) @base))
        (interface_declaration name: (identifier) @name (base_list (identifier) @base))
    ]
]])

return M
