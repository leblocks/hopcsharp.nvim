local config = require('hopcsharp.config')

describe('config', function()
    it('__get_value empty', function()
        local result = config.__get_value({}, { 'a', 'b', 'c' })
        assert(result == nil)
    end)

    it('__get_value nil', function()
        local result = config.__get_value(nil, { 'a', 'b', 'c' })
        assert(result == nil)
    end)

    it('__get_value happy', function()
        local object = {
            a = {
                b = {
                    c = 133
                }
            }
        }

        local result = config.__get_value(object, { 'a', 'b', 'c' })
        assert(result == object.a.b.c)
    end)
end)
