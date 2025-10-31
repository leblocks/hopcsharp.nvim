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

M.reference = utils.__get_query([[
    [
        (invocation_expression function: (identifier) @name)
        (invocation_expression function: (generic_name (identifier) @name))
        (invocation_expression function: (member_access_expression name: (identifier) @name))
        (invocation_expression function: (member_access_expression name: (generic_name (identifier) @name)))
        (variable_declaration type: (identifier) @name)
        (variable_declaration type: (generic_name (identifier) @name))
        (object_creation_expression type: (identifier) @name)
        (object_creation_expression type: (generic_name (identifier) @name))
        (attribute name: (identifier) @name)
    ]
]])

return M
