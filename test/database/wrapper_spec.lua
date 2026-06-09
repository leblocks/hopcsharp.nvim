local config = require('hopcsharp.config')
local database = require('hopcsharp.database')
local debug = require('hopcsharp.debug')
local wrapper = require('hopcsharp.database.wrapper')
local utils = require('test.utils')

local prepare_environment = function()
    -- reset logs and main databases
    database.__drop_db()
    debug.__get_db():eval([[ delete from logs ]])

    -- enable logging
    config.__set_config({ debug = true })
    utils.init_test_database()

    return database.__get_unwrapped_db(), debug.__get_db()
end

describe('wrapper', function()
    it('wrapped eval logs call and returns query result - no params', function()
        local main_db, logs_db = prepare_environment()
        local wrapped = wrapper.__get_wrapper(main_db)

        local rows = wrapped:eval([[ select * from definitions ]])
        assert(#rows > 0)

        local messages = logs_db:eval([[ select * from logs where message like 'eval%' ]])
        assert(#messages > 1)
    end)

    it('wrapped eval logs call and returns query result', function()
        local main_db, logs_db = prepare_environment()
        local wrapped = wrapper.__get_wrapper(main_db)

        local rows = wrapped:eval([[ select * from definitions where name = :name ]], { name = 'AlfaMethod' })
        assert(#rows > 0)

        local messages = logs_db:eval([[ select * from logs where message like 'eval%' ]])
        assert(#messages > 1)
    end)


    it('wrapped execute logs call and returns query result', function()
        local main_db, logs_db = prepare_environment()
        local wrapped = wrapper.__get_wrapper(main_db)

        local result = wrapped:execute('PRAGMA optimize')
        assert(result)

        local messages = logs_db:eval([[ select * from logs where message like 'execute%' ]])
        assert(#messages == 1)
        assert(messages[1].message == 'execute PRAGMA optimize')
    end)

    it('wrapped select logs call and returns query result', function()
        local main_db, logs_db = prepare_environment()
        local wrapped = wrapper.__get_wrapper(main_db)

        local rows = wrapped:select('definitions', { where = { name = 'AlfaMethod' } })
        assert(#rows > 0)

        local messages = logs_db:eval([[ select * from logs where message like 'select%' ]])
        assert(#messages > 1)
    end)

    it('wrapped delete logs call and returns query result', function()
        local main_db, logs_db = prepare_environment()
        local wrapped = wrapper.__get_wrapper(main_db)

        local result = wrapped:delete('definitions', { where = { name = 'AlfaMethod' } })
        assert(result)

        local messages = logs_db:eval([[ select * from logs where message like 'delete%' ]])
        assert(#messages == 1)
    end)

    it('wrapped insert logs call and returns query result', function()
        local main_db, logs_db = prepare_environment()
        local wrapped = wrapper.__get_wrapper(main_db)

        local result = wrapped:insert('namespaces', { name = 'testnamespace' })
        assert(result)

        local messages = logs_db:eval([[ select * from logs where message like 'insert%' ]])
        assert(#messages > 1)
    end)
end)
