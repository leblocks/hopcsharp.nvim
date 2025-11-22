local utils = require('test.utils')
local database = require('hopcsharp.database')

describe('parse.namespace', function()
    it('__parse_namespace populates database correctly', function()
        utils.init_test_database()
        local db = database.__get_db()

        local namespaces = db:select('namespaces', { where = { name = 'This.Is.Namespace.One' } })
        assert(#namespaces == 1)

        namespaces = db:select('namespaces', { where = { name = 'This.Is.Namespace.Two' } })
        assert(#namespaces == 1)

        namespaces = db:select('namespaces', { where = { name = 'This.Is.Scoped.Namespace' } })
        assert(#namespaces == 1)
    end)

    it('__parse_namespace inserts empty namespace correctly', function()
        utils.init_test_database()
        local db = database.__get_db()
        local namespaces = db:select('namespaces', { where = { name = 'n\\a' } })
        assert(#namespaces == 1)
    end)
end)
