local database = require('hopcsharp.database')
local query = require('hopcsharp.database.query')


describe('query', function()
    it('can invoke get_definition_by_name query', function()
        local db = database.__get_db()
        assert(db:eval(query.get_definition_by_name, { name = 'test' }))
    end)

    it('can invoke get_definition_by_name_and_type query', function()
        local db = database.__get_db()
        assert(db:eval(query.get_definition_by_name_and_type, { name = 'test', type = 23 }))
    end)

    it('can invoke get_definition_by_type query', function()
        local db = database.__get_db()
        assert(db:eval(query.get_definition_by_type, { type = 23 }))
    end)

    it('can invoke get_implementations_by_name query', function()
        local db = database.__get_db()
        assert(db:eval(query.get_implementations_by_name, { name = 'test' }))
    end)
end)
