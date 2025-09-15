local utils = require('hopcsharp.parse.utils')

local M = {}

-- type_parameter_list

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
        (class_declaration name: (identifier) @name (base_list [(identifier)(generic_name)] @base))
        (struct_declaration name: (identifier) @name (base_list [(identifier)(generic_name)] @base))
        (record_declaration name: (identifier) @name (base_list [(identifier)(generic_name)] @base))
        (interface_declaration name: (identifier) @name (base_list [(identifier)(generic_name)] @base))
    ]
]])

M.type_parameter_list = utils.__get_query("[[ (type_parameter_list) @name ]]")

return M
