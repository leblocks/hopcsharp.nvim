local utils = require('hopcsharp.parse.utils')

local M = {}

M.namespace = utils.__get_query([[
    [(namespace_declaration (qualified_name) @name)(file_scoped_namespace_declaration (qualified_name) @name)]
]])

M.class_declaration = utils.__get_query('(class_declaration) @class')
M.class_identifier = utils.__get_query('(class_declaration (identifier) @name)')

M.interface_declaration = utils.__get_query('(interface_declaration) @interface')
M.interface_identifier = utils.__get_query('(interface_declaration (identifier) @name)')

return M
