local database = require('hopcsharp.database')

describe('db', function()
    it('__get_db_file_name works for windows path', function()
        local name = database.__get_db_file_name('C:\\Users\\john\\repos\\dotfiles')
        assert(name == 'C--Users-john-repos-dotfiles.sql')
    end)

    it('__get_db_file_name works for linux path', function()
        local name = database.__get_db_file_name('/home/john/nvim')
        assert(name == 'home-john-nvim.sql')
    end)

    it('__init_db returns db object', function()
        local db = database.__init_db()
        assert(db ~= nil)
    end)

    it('__insert_file positive flow', function()
        local db = database.__init_db()

        local id1 = database.__insert_file(db, "test_path")
        local id2 = database.__insert_file(db, "test_path")
        assert(id1 == id2)

        local rows = db:eval("select count(*) as count from files where path = :path", { path = "test_path" })
        assert(rows[1].count == 1)
    end)

    it('__insert_namespace positive flow', function()
        local db = database.__init_db()

        local id1 = database.__insert_namespace(db, "namespace1")
        local id2 = database.__insert_namespace(db, "namespace1")
        assert(id1 == id2)

        local rows = db:eval("select count(*) as count from namespaces where name = :name", { name = "namespace1" })
        assert(rows[1].count == 1)
    end)
end)
