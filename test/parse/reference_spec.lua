local database = require('hopcsharp.database')
local query = require('hopcsharp.database.query')
local utils = require('hopcsharp.database.utils')
local BufferedWriter = require('hopcsharp.database.buffer')

local parse = require('hopcsharp.parse')
local definition = require('hopcsharp.parse.reference')

describe('parse.reference', function()
    it('__parse_reference populates database correctly', function()
        database.__drop_db()
        local path = vim.fn.getcwd() .. '/test/sources/hop_to_reference.cs'
        local writer = BufferedWriter:new(database.__get_db(), 1)
        local db = database.__get_db()

        parse.__parse_tree(path, function(tree, path_id, file_content, wr)
            definition.__parse_reference(tree:root(), path_id, file_content, wr)

            -- attribute TestAttr
            local rows = db:eval(
                query.get_reference_by_name_and_type,
                { name = 'TestAttr', type = utils.reference_types.ATTRIBUTE }
            )

            assert(#rows == 1)
            assert(rows[1].path:match('test/sources/hop_to_reference.cs$'))
            assert(rows[1].type == utils.reference_types.ATTRIBUTE)
            assert(rows[1].name == 'TestAttr')

            -- attribute AttributeWow
            rows = db:eval(
                query.get_reference_by_name_and_type,
                { name = 'AttributeWow', type = utils.reference_types.ATTRIBUTE }
            )

            assert(#rows == 1)
            assert(rows[1].path:match('test/sources/hop_to_reference.cs$'))
            assert(rows[1].type == utils.reference_types.ATTRIBUTE)
            assert(rows[1].name == 'AttributeWow')

            -- method Method1
            rows = db:eval(
                query.get_reference_by_name_and_type,
                { name = 'Method1', type = utils.reference_types.METHOD_INVOCATION }
            )

            assert(#rows == 4)
            for _, row in ipairs(rows) do
                assert(row.name == 'Method1')
                assert(row.path:match('test/sources/hop_to_reference.cs$'))
                assert(row.type == utils.reference_types.METHOD_INVOCATION)
            end

            -- class Class2
            rows = db:eval(
                query.get_reference_by_name_and_type,
                { name = 'Class2', type = utils.reference_types.OBJECT_CREATION }
            )

            assert(#rows == 1)
            for _, row in ipairs(rows) do
                assert(row.name == 'Class2')
                assert(row.path:match('test/sources/hop_to_reference.cs$'))
                assert(row.type == utils.reference_types.OBJECT_CREATION)
            end

            -- class Class2 as variable declaration
            rows = db:eval(
                query.get_reference_by_name_and_type,
                { name = 'Class2', type = utils.reference_types.VARIABLE_DECLARATION }
            )

            assert(#rows == 2)
            for _, row in ipairs(rows) do
                assert(row.name == 'Class2')
                assert(row.path:match('test/sources/hop_to_reference.cs$'))
                assert(row.type == utils.reference_types.VARIABLE_DECLARATION)
            end

            -- method Run
            rows = db:eval(
                query.get_reference_by_name_and_type,
                { name = 'Run', type = utils.reference_types.METHOD_INVOCATION }
            )

            assert(#rows == 2)
            for _, row in ipairs(rows) do
                assert(row.name == 'Run')
                assert(row.path:match('test/sources/hop_to_reference.cs$'))
                assert(row.type == utils.reference_types.METHOD_INVOCATION)
            end
        end, writer)
    end)
end)
