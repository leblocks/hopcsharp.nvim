local database = require('hopcsharp.database')
local database_utils = require('hopcsharp.database.utils')
local query = require('hopcsharp.database.query')
local test_utils = require('test.utils')

describe('parse.type_argument', function()
    it('populates database correctly', function()
        test_utils.init_test_database()

        local db = database.__get_db()

        local rows = db:eval(query.get_reference_by_name_and_type('Meow',database_utils.reference_types.TYPE_ARGUMENT))

        assert(#rows == 1)
        assert(rows[1].name == 'Meow')
        assert(rows[1].namespace == 'This.Is.Reference.Namespace')
        assert(rows[1].path:match('test/sources/hop_to_reference.cs$'))
        assert(rows[1].row == 23)
        assert(rows[1].column == 21)
        assert(rows[1].type == database_utils.reference_types.TYPE_ARGUMENT)
    end)
end)
