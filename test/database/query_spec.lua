local database = require('hopcsharp.database')
local query = require('hopcsharp.database.query')


describe('query', function()
    it('can invoke get_object_by_name query', function()
        local db = database.__get_db()
        assert(db:eval(query.get_object_by_name, { name = 'test' }))
    end)

    it('can invoke get_definition_by_name query', function()
        local db = database.__get_db()
        assert(db:eval(query.get_definition_by_name, { name = 'test' }))
    end)

    it('can invoke get_attribute_by_name query', function()
        local db = database.__get_db()
        assert(db:eval(query.get_attribute_by_name, { name = 'test' }))
    end)

    it('can invoke get_method_by_name query', function()
        local db = database.__get_db()
        assert(db:eval(query.get_method_by_name, { name = 'test' }))
    end)
end)
