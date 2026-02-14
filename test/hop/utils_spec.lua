local hop_utils = require('hopcsharp.hop.utils')

describe('hop_utils', function()
    it('__populate_quickfix calls type converter', function()
        local type_converter_called = false

        local type_converter = function()
            type_converter_called = true
        end

        local entries = {
            { path = 'testpath1', row = 1, col = 1, type = 42, namespace = 'namespace1' },
            { path = 'testpath2', row = 1, col = 1, type = 42, namespace = 'namespace2' },
            { path = 'testpath3', row = 1, col = 1, type = 42, namespace = 'namespace3' },
            { path = 'testpath4', row = 1, col = 1, type = 42, namespace = 'namespace4' },
        }

        -- check that qf is empty
        assert(#vim.fn.getqflist() == 0)

        -- this one runs via vim.schedule
        -- there is no safe way to assume that it (that I'm aware of)
        -- finished something
        hop_utils.__populate_quickfix(entries, false, type_converter)

        assert(type_converter_called)
    end)
end)
