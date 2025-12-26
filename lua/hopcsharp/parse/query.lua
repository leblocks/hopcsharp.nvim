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
        (class_declaration name: (identifier) @name (base_list [(identifier)(generic_name)] @base))
        (struct_declaration name: (identifier) @name (base_list [(identifier)(generic_name)] @base))
        (record_declaration name: (identifier) @name (base_list [(identifier)(generic_name)] @base))
        (interface_declaration name: (identifier) @name (base_list [(identifier)(generic_name)] @base))
    ]
]])

M.reference = utils.__get_query([[
[
      (invocation_expression function: [
        (identifier) @name
        (generic_name (identifier) @name)
        (member_access_expression name: (identifier) @name)
        (member_access_expression name: (generic_name (identifier) @name))
      ])

      (variable_declaration type: [
            (identifier) @name
            (generic_name (identifier) @name)
          ]
          ;; ignore those predefines types
          ;; data taken from this query on a db parsed on reference source of dotnet
          ;; select count() as cnt, name from reference where type = 4 group by name order by cnt desc limit 100;
          (#not-any-of? @name
            "Action"
            "Array"
            "ArrayList"
            "Boolean"
            "Collection"
            "DateTime"
            "Dictionary"
            "Enumerable"
            "Exception"
            "Func"
            "Guid"
            "HashSet"
            "Hashtable"
            "ICollection"
            "IDictionary"
            "IEnumerable"
            "IList"
            "IntPtr"
            "List"
            "MemoryStream"
            "MethodInfo"
            "Object"
            "Queue"
            "Set"
            "Stack"
            "Stream"
            "String"
            "StringBuilder"
            "Task"
            "TimeSpan"
            "Tuple"
            "Type"
            "UInt32"
          )
      )

      (object_creation_expression type: [
        (identifier) @name
        (generic_name (identifier) @name)
      ])

      (attribute name: (identifier) @name)
    ]
]])

M.namespace_identifier = utils.__get_query([[
    [
        (file_scoped_namespace_declaration name: (qualified_name) @name)
        (namespace_declaration name: (qualified_name) @name)
    ]
]])

M.using_identifier = utils.__get_query([[
    [
        (using_directive (qualified_name) @name)
        (using_directive (identifier) @name)
    ]
]])

M.type_argument_list = utils.__get_query([[
    (type_argument_list (identifier) @name
          ;; ignore those predefines types
          ;; data taken from this query on a db parsed on reference source of dotnet
          ;; select count() as cnt, name from reference where type = 4 group by name order by cnt desc limit 100;
          (#not-any-of? @name
            "Action"
            "Array"
            "ArrayList"
            "Boolean"
            "Collection"
            "DateTime"
            "Dictionary"
            "Enumerable"
            "Exception"
            "Func"
            "Guid"
            "HashSet"
            "Hashtable"
            "ICollection"
            "IDictionary"
            "IEnumerable"
            "IList"
            "IntPtr"
            "List"
            "MemoryStream"
            "MethodInfo"
            "Object"
            "Queue"
            "Set"
            "Stack"
            "Stream"
            "String"
            "StringBuilder"
            "Task"
            "TimeSpan"
            "Tuple"
            "Type"
            "UInt32"
          )
    )
]])

return M
