local database = require('hopcsharp.database')
local parse_utils = require('hopcsharp.parse.utils')

describe('hopcsharp', function()
    it('can require hopcsharp', function()
        require('hopcsharp')
    end)

    it('__init_database adds parse history', function()
        local db = database.__get_db()
        require('hopcsharp').__init_database()
        local commit = parse_utils.__get_commit_hash()
        local history = db:eval([[ SELECT * FROM parse_history ]])
        assert(#history == 1)
        assert(history[1].id == 1)
        assert(history[1].commit_hash == commit)
    end)

    it('__init_database - incremental_parsing true', function()
        -- TOOD
    end)

    it('__init_database - incremental_parsing false', function()
        -- TOOD
    end)

    it('__init_database - incremental_parsing true - does not drop history', function()
        require('hopcsharp').__init_database()
        require('hopcsharp').__init_database(true)
        local db = database.__get_db()
        local history = db:eval([[ SELECT * FROM parse_history ]])
        assert(#history == 2)
        assert(history[1].id == 1)
        assert(history[2].id == 2)
    end)

    it('__init_database - incremental_parsing false - drops whole db', function()
        -- TOOD
    end)
end)
