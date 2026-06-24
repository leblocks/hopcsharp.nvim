local database = require('hopcsharp.database')
local history = require('hopcsharp.parse.history')

describe('history', function()
    it('__add_parse_history - happy path', function()
        history.__add_parse_history_entry('somecommithash')
        local rows = database.__get_db():eval([[ SELECT * FROM parse_history ]])
        assert(#rows == 1)
        assert(rows[1].parse_date ~= '')
        assert(rows[1].commit_hash == 'somecommithash')
    end)

    it('__add_parse_history - nil', function()
        -- TODO
    end)

    it('__add_parse_history - empty', function()
        -- TODO
    end)

    -- TODO .__get_parse_history
end)

