local database = require('hopcsharp.database')
local query = require('hopcsharp.database.query')


describe('query', function()
    it('can invoke get_class_by_name query', function()
        local db = database.__get_db()
        assert(db:eval(query.get_class_by_name, { name = 'test' }))
    end)

    it('can invoke get_interface_by_name query', function()
        local db = database.__get_db()
        assert(db:eval(query.get_interface_by_name, { name = 'test' }))
    end)

    it('can invoke get_definition_by_name query', function()
        local db = database.__get_db()
        assert(db:eval(query.get_definition_by_name, { name = 'test' }))
    end)

end)

