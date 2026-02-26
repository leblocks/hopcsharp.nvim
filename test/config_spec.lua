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
                    c = 133,
                },
            },
        }

        local result = config.__get_value(object, { 'a', 'b', 'c' })
        assert(result == object.a.b.c)
    end)

    it('__get_config has correct default values', function()
        local default_config = config.__get_config()
        assert(default_config ~= nil)

        assert(default_config.database ~= nil)
        assert(default_config.database.buffer_size == 10000)
        assert(default_config.database.folder_path == vim.fn.stdpath('state'))

        assert(default_config.hop ~= nil)
        assert(default_config.hop.jump_on_quickfix == false)
        assert(default_config.hop.filter_entry_under_cursor == true)
    end)

    it('__set_config with empty objects does not ruin configuration', function()
        config.__set_config({
            hop = nil,
            database = {},
        })

        local actual_config = config.__get_config()

        assert(actual_config.database ~= nil)
        assert(actual_config.database.buffer_size == 10000)
        assert(actual_config.database.folder_path == vim.fn.stdpath('state'))

        assert(actual_config.hop ~= nil)
        assert(actual_config.hop.jump_on_quickfix == false)
        assert(actual_config.hop.filter_entry_under_cursor == true)
    end)

    it('__set_config happy path', function()
        config.__set_config({

            hop = {
                jump_on_quickfix = true,
                filter_entry_under_cursor = false,
            },

            database = {
                buffer_size = 142,
                folder_path = 'nowhereland',
            },
        })

        local actual_config = config.__get_config()

        assert(actual_config.database ~= nil)
        assert(actual_config.database.buffer_size == 142)
        assert(actual_config.database.folder_path == 'nowhereland')

        assert(actual_config.hop ~= nil)
        assert(actual_config.hop.jump_on_quickfix == true)
        assert(actual_config.hop.filter_entry_under_cursor == false)
    end)
end)
