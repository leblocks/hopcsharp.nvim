local debug = require('hopcsharp.debug')
local config = require('hopcsharp.config')

describe('debug', function()
    it('__log logs a message when debug = true', function()
        config.__set_config({ debug = true })
        local db = debug.__get_db()
        db:eval([[ delete from logs ]])

        debug.__log('this is a test message', 0)

        local rows = db:eval([[ select * from logs ]])
        print(vim.inspect(rows))
        assert(#rows == 1)
    end)

    it('__log does not log a message when debug = false', function()
        -- TODO
    end)
end)
