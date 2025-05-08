local utils = require('hopcsharp.parse.utils')

local M = {}

M.namespace = utils.__get_query([[
    [(namespace_declaration (qualified_name) @name)(file_scoped_namespace_declaration (qualified_name) @name)]
]])

M.class_declaration = utils.__get_query('(class_declaration) @class')
M.class_identifier = utils.__get_query('(class_declaration name: (identifier) @name)')

M.interface_declaration = utils.__get_query('(interface_declaration) @interface')
M.interface_identifier = utils.__get_query('(interface_declaration name: (identifier) @name)')

M.enum_declaration = utils.__get_query('(enum_declaration) @enum')
M.enum_identifier = utils.__get_query('(enum_declaration name: (identifier) @name)')

M.struct_declaration = utils.__get_query('(struct_declaration) @struct')
M.struct_identifier = utils.__get_query('(struct_declaration name: (identifier) @name)')

M.record_declaration = utils.__get_query('(record_declaration) @record')
M.record_identifier = utils.__get_query('(record_declaration name: (identifier) @name)')

M.method_declaration = utils.__get_query('(method_declaration) @method')
M.method_identifier = utils.__get_query('(method_declaration name: (identifier) @name)')

M.constructor_declaration = utils.__get_query('(constructor_declaration) @constructor')
M.constructor_identifier = utils.__get_query('(constructor_declaration name: (identifier) @name)')

return M
