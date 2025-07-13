local database = require('hopcsharp.database')
local query = require('hopcsharp.database.query')
local utils = require('hopcsharp.database.utils')
local BufferedWriter = require('hopcsharp.database.buffer')

local parse = require('hopcsharp.parse')
local definition = require('hopcsharp.parse.definition')

describe('parse.definition', function()
    it('__parse_definitions populates database correctly', function()
        database.__drop_db()
        local path = vim.fn.getcwd() .. '/test/sources/Class1.cs'
        local writer = BufferedWriter:new(database.__get_db(), 1)
        local db = database.__get_db()

        parse.__parse_tree(path, function(tree, path_id, file_content, wr)
            definition.__parse_definitions(tree:root(), path_id, file_content, wr)

            local rows = db:eval(query.get_definition_by_name_and_type, { name = 'Class1', type = utils.__types.CLASS })

            -- class Class1
            assert(#rows == 1)
            assert(rows[1].name == 'Class1')
            assert(rows[1].path:match('test/sources/Class1.cs$'))
            assert(rows[1].type == utils.__types.CLASS)

            -- method Foo
            rows = db:eval(query.get_definition_by_name_and_type, { name = 'Foo', type = utils.__types.METHOD })
            assert(#rows == 1)
            assert(rows[1].name == 'Foo')
            assert(rows[1].path:match('test/sources/Class1.cs$'))
            assert(rows[1].type == utils.__types.METHOD)

            -- method Bar
            rows = db:eval(query.get_definition_by_name_and_type, { name = 'Bar', type = utils.__types.METHOD })
            assert(#rows == 1)
            assert(rows[1].name == 'Bar')
            assert(rows[1].path:match('test/sources/Class1.cs$'))
            assert(rows[1].type == utils.__types.METHOD)

            -- constructor
            rows = db:eval(query.get_definition_by_name_and_type, { name = 'Class1', type = utils.__types.CONSTRUCTOR })
            assert(#rows == 1)
            assert(rows[1].name == 'Class1')
            assert(rows[1].path:match('test/sources/Class1.cs$'))
            assert(rows[1].type == utils.__types.CONSTRUCTOR)

            -- enum
            rows = db:eval(query.get_definition_by_name_and_type, { name = 'Enum1', type = utils.__types.ENUM })
            assert(#rows == 1)
            assert(rows[1].name == 'Enum1')
            assert(rows[1].path:match('test/sources/Class1.cs$'))
            assert(rows[1].type == utils.__types.ENUM)

            -- struct
            rows = db:eval(query.get_definition_by_name_and_type, { name = 'Struct1', type = utils.__types.STRUCT })
            assert(#rows == 1)
            assert(rows[1].name == 'Struct1')
            assert(rows[1].path:match('test/sources/Class1.cs$'))
            assert(rows[1].type == utils.__types.STRUCT)

            -- record
            rows = db:eval(query.get_definition_by_name_and_type, { name = 'Record1', type = utils.__types.RECORD })
            assert(#rows == 1)
            assert(rows[1].name == 'Record1')
            assert(rows[1].path:match('test/sources/Class1.cs$'))
            assert(rows[1].type == utils.__types.RECORD)

            -- interface
            rows =
                db:eval(query.get_definition_by_name_and_type, { name = 'IInterface', type = utils.__types.INTERFACE })

            assert(#rows == 1)
            assert(rows[1].name == 'IInterface')
            assert(rows[1].path:match('test/sources/Class1.cs$'))
            assert(rows[1].type == utils.__types.INTERFACE)
        end, writer)
    end)
end)
