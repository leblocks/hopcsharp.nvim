local database = require('hopcsharp.database')

describe('database', function()
    it('__init_db returns db object', function()
        local db = database.__init_db()
        assert(db ~= nil)
    end)

    it('__drop_db can be called', function()
        database.__drop_db()
    end)
end)
