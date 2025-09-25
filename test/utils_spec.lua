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

    it('__block_on_processing - stops on processing', function()
        vim.g.hopcsharp_processing = true

        local called = false
        utils.__block_on_processing(function()
            called = true
        end);

        assert(not called)
    end)

    it('__block_on_processing - returns result', function()
        vim.g.hopcsharp_processing = false
        local called = false
        local result = utils.__block_on_processing(function()
            called = true
            return 42
        end);

        assert(called)
        assert(result == 42)
    end)

    it('__scheduled_iteration - empty table', function()
        local called = false
        utils.__scheduled_iteration({}, function(i, item, items)
            called = true
        end)
        assert(not called)
    end)

    it('__scheduled_iteration - nil', function()
        local called = false
        utils.__scheduled_iteration(nil, function(i, item, items)
            called = true
        end)
        assert(not called)
    end)

    it('__scheduled_iteration - dictionary', function()
    end)

    it('__scheduled_iteration - happy path', function()
        local entries = {
            "test",
            "test1",
            "test2",
            "test3",
        }

        utils.__scheduled_iteration(entries, function(i, item, items)
            assert(items[i] == item)
        end)
    end)
end)
