local config = require('hopcsharp.config')
local debug = require('hopcsharp.debug')
local utils = require('hopcsharp.debug.utils')

describe('debug', function()
    it('__log logs a message when debug = true', function()
        config.__set_config({ debug = true })
        local db = debug.__get_db()
        db:eval([[ delete from logs ]])

        debug.__log('this is a test message', utils.level.DEBUG)

        local rows = db:eval([[ select * from logs ]])
        assert(#rows == 1)
        assert(rows[1].message == 'this is a test message')
        assert(rows[1].level == utils.level.DEBUG)
    end)

    it('__log default level is INFO', function()
        config.__set_config({ debug = true })
        local db = debug.__get_db()
        db:eval([[ delete from logs ]])

        debug.__log('this is a test message')

        local rows = db:eval([[ select * from logs ]])
        assert(#rows == 1)
        assert(rows[1].message == 'this is a test message')
        assert(rows[1].level == utils.level.INFO)
    end)

    it('__log_info logs INFO', function()
        config.__set_config({ debug = true })
        local db = debug.__get_db()
        db:eval([[ delete from logs ]])

        debug.__log_info('this is a test message')

        local rows = db:eval([[ select * from logs ]])
        assert(#rows == 1)
        assert(rows[1].message == 'this is a test message')
        assert(rows[1].level == utils.level.INFO)
    end)

    it('__log_warning logs WARNING', function()
        config.__set_config({ debug = true })
        local db = debug.__get_db()
        db:eval([[ delete from logs ]])

        debug.__log_warning('this is a test message')

        local rows = db:eval([[ select * from logs ]])
        assert(#rows == 1)
        assert(rows[1].message == 'this is a test message')
        assert(rows[1].level == utils.level.WARNING)
    end)

    it('__log_error logs ERROR', function()
        config.__set_config({ debug = true })
        local db = debug.__get_db()
        db:eval([[ delete from logs ]])

        debug.__log_error('this is a test message')

        local rows = db:eval([[ select * from logs ]])
        assert(#rows == 1)
        assert(rows[1].message == 'this is a test message')
        assert(rows[1].level == utils.level.ERROR)
    end)

    it('__log_debug logs DEBUG', function()
        config.__set_config({ debug = true })
        local db = debug.__get_db()
        db:eval([[ delete from logs ]])

        debug.__log_debug('this is a test message')

        local rows = db:eval([[ select * from logs ]])
        assert(#rows == 1)
        assert(rows[1].message == 'this is a test message')
        assert(rows[1].level == utils.level.DEBUG)
    end)

    it('__log does not log a message when debug = false', function()
        config.__set_config({ debug = false })
        local db = debug.__get_db()
        db:eval([[ delete from logs ]])

        debug.__log('should not print')
        debug.__log('should not print')
        debug.__log('should not print')
        debug.__log('should not print')

        local rows = db:eval([[ select * from logs ]])
        assert(rows)
    end)
end)
