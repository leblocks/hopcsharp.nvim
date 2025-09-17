local utils = require('hopcsharp.utils')

describe('utils', function()
    it('__contains - happy path', function()
        local dummy = { 'banana', 'apple' }
        assert(utils.__contains(dummy, 'apple'))
        assert(not utils.__contains(dummy, 'meow'))
    end)

    it('__contains - nill entries', function()
        assert(not utils.__contains(nil, 'apple'))
    end)

    it('__find_first - no element', function()
        local dummy = {
            { name = 'test1' },
            { name = 'test2' },
            { name = 'test3' },
        }

        assert(utils.__find_first(dummy, 'name', 'test4') == nil)
    end)

    it('__find_first - happy path', function()
        local dummy = {
            { name = 'test1' },
            { name = 'test2' },
            { name = 'test3' },
        }

        local result = utils.__find_first(dummy, 'name', 'test3')
        assert(result ~= nil)
        assert(result.name == 'test3')
    end)

    it('__find_first - nil table', function()
        local result = utils.__find_first(nil, 'name', 'test3')
        assert(result == nil)
    end)

    it('__find_table - nil table', function()
        local result = utils.__find_table(nil, 'name', 'test')
        assert(result ~= nil)
        assert(#result == 0)
    end)

    it('__find_table - empty result', function()
        local dummy = {
            { name = 'test1' },
            { name = 'test2' },
            { name = 'test3' },
        }

        local result = utils.__find_table(dummy, 'name', 'test6')
        assert(result ~= nil)
        assert(#result == 0)
    end)

    it('__find_table - multiple matches', function()
        local dummy = {
            { name = 'test1' },
            { name = 'test2' },
            { name = 'test1' },
        }

        local result = utils.__find_table(dummy, 'name', 'test1')
        assert(result ~= nil)
        assert(#result == 2)
        assert(result[1].name == 'test1')
        assert(result[2].name == 'test1')
    end)

    it('__trim_spaces', function()
        assert('test1' == utils.__trim_spaces('test 1'))
        assert('test1' == utils.__trim_spaces('t est    1'))
        assert('test1' == utils.__trim_spaces('t est    1     '))
        assert('test1' == utils.__trim_spaces(' t est    1     '))
        assert('test1' == utils.__trim_spaces(' t e s t  1     '))
    end)
end)
