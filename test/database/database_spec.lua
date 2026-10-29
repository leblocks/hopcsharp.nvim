local database = require('hopcsharp.database')
local config = require('hopcsharp.config')
local utils = require('test.utils')

describe('database', function()
    it('__init_db returns db object', function()
        local db = database.__init_db()
        assert(db ~= nil)
    end)

    it('__drop_db can be called', function()
        database.__drop_db()
    end)

    it('__drop_by_path - empty path', function()
        utils.init_test_database()
        database.__drop_by_path({})
    end)

    it('__drop_by_path - nil path', function()
        utils.init_test_database()
        database.__drop_by_path(nil)
    end)

    it('__drop_by_path - non existing paths', function()
        utils.init_test_database()
        database.__drop_by_path({
            vim.fs.normalize('meow//woof'),
            vim.fs.normalize('woofs//meow'),
        })
    end)

    it('__drop_by_path - happy path', function()
        config.__set_config({ debug = true })
        utils.init_test_database()

        local path = vim.fs.normalize('test//sources//get_type_hierarchy.cs')
        local db = database.__get_db()

        local file = db:select('files', { where = { path = path } })
        database.__drop_by_path(path)
        local count = db:eval([[SELECT COUNT(1) FROM files WHERE id = :id ]], { id = file[1].id })
        assert(count[1]['COUNT(1)'] == 0)

        count = db:eval([[SELECT COUNT(1) FROM namespaces WHERE path_id = :id ]], { id = file[1].id })
        assert(count[1]['COUNT(1)'] == 0)

        count = db:eval([[SELECT COUNT(1) FROM usings WHERE path_id = :id ]], { id = file[1].id })
        assert(count[1]['COUNT(1)'] == 0)

        count = db:eval([[SELECT COUNT(1) FROM reference WHERE path_id = :id ]], { id = file[1].id })
        assert(count[1]['COUNT(1)'] == 0)

        count = db:eval([[SELECT COUNT(1) FROM inheritance WHERE path_id = :id ]], { id = file[1].id })
        assert(count[1]['COUNT(1)'] == 0)

        count = db:eval([[SELECT COUNT(1) FROM definitions WHERE path_id = :id ]], { id = file[1].id })
        assert(count[1]['COUNT(1)'] == 0)
    end)
end)
