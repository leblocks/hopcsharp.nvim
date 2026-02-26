local database = require('hopcsharp.database')
local query = require('hopcsharp.database.query')
local utils = require('hopcsharp.database.utils')
local BufferedWriter = require('hopcsharp.database.buffer')

local parse = require('hopcsharp.parse')
local definition = require('hopcsharp.parse.reference')
local namespace = require('hopcsharp.parse.namespace')

describe('parse.reference', function()
    it('__parse_reference populates database correctly', function()
        database.__drop_db()
        local path = vim.fn.getcwd() .. '/test/sources/hop_to_reference.cs'
        local writer = BufferedWriter:new(database.__get_db(), 1)
        local db = database.__get_db()

        parse.__parse_tree(path, function(tree, path_id, file_content, wr)
            local namespace_id = namespace.__parse_namespaces(tree:root(), file_content)
            definition.__parse_reference(tree:root(), path_id, namespace_id, file_content, wr)

            -- attribute TestAttr
            local rows = db:eval(query.get_reference_by_name_and_type('TestAttr', utils.reference_types.ATTRIBUTE))

            assert(#rows == 1)
            assert(rows[1].path:match('test/sources/hop_to_reference.cs$'))
            assert(rows[1].type == utils.reference_types.ATTRIBUTE)
            assert(rows[1].name == 'TestAttr')
            assert(rows[1].namespace == 'This.Is.Reference.Namespace')

            -- attribute AttributeWow
            rows = db:eval(query.get_reference_by_name_and_type('AttributeWow', utils.reference_types.ATTRIBUTE))

            assert(#rows == 1)
            assert(rows[1].path:match('test/sources/hop_to_reference.cs$'))
            assert(rows[1].type == utils.reference_types.ATTRIBUTE)
            assert(rows[1].name == 'AttributeWow')
            assert(rows[1].namespace == 'This.Is.Reference.Namespace')

            -- method Method1
            rows = db:eval(query.get_reference_by_name_and_type('Method1', utils.reference_types.METHOD_INVOCATION))

            assert(#rows == 4)
            for _, row in ipairs(rows) do
                assert(row.name == 'Method1')
                assert(row.path:match('test/sources/hop_to_reference.cs$'))
                assert(row.type == utils.reference_types.METHOD_INVOCATION)
                assert(row.namespace == 'This.Is.Reference.Namespace')
            end

            -- class Class2
            rows = db:eval(query.get_reference_by_name_and_type('Class2', utils.reference_types.OBJECT_CREATION))

            assert(#rows == 1)
            for _, row in ipairs(rows) do
                assert(row.name == 'Class2')
                assert(row.path:match('test/sources/hop_to_reference.cs$'))
                assert(row.type == utils.reference_types.OBJECT_CREATION)
                assert(row.namespace == 'This.Is.Reference.Namespace')
            end

            -- class Class2 as variable declaration
            rows = db:eval(query.get_reference_by_name_and_type('Class2', utils.reference_types.VARIABLE_DECLARATION))

            assert(#rows == 2)
            for _, row in ipairs(rows) do
                assert(row.name == 'Class2')
                assert(row.path:match('test/sources/hop_to_reference.cs$'))
                assert(row.type == utils.reference_types.VARIABLE_DECLARATION)
                assert(row.namespace == 'This.Is.Reference.Namespace')
            end

            -- method Run
            rows = db:eval(query.get_reference_by_name_and_type('Run', utils.reference_types.METHOD_INVOCATION))

            assert(#rows == 2)
            for _, row in ipairs(rows) do
                assert(row.name == 'Run')
                assert(row.path:match('test/sources/hop_to_reference.cs$'))
                assert(row.type == utils.reference_types.METHOD_INVOCATION)
                assert(row.namespace == 'This.Is.Reference.Namespace')
            end

            -- typeof
            rows = db:eval(query.get_reference_by_name_and_type('Class2', utils.reference_types.TYPEOF_EXPRESSION))

            assert(#rows == 1)
            assert(rows[1].name == 'Class2')
            assert(rows[1].path:match('test/sources/hop_to_reference.cs$'))
            assert(rows[1].type == utils.reference_types.TYPEOF_EXPRESSION)
            assert(rows[1].namespace == 'This.Is.Reference.Namespace')

            -- typeof
            rows = db:eval(query.get_reference_by_name_and_type('NonExistingType', utils.reference_types.PARAMETER))

            assert(#rows == 1)
            assert(rows[1].name == 'NonExistingType')
            assert(rows[1].path:match('test/sources/hop_to_reference.cs$'))
            assert(rows[1].type == utils.reference_types.PARAMETER)
            assert(rows[1].namespace == 'This.Is.Reference.Namespace')
        end, writer)
    end)
end)
