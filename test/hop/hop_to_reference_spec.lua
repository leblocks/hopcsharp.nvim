local hop = require('hopcsharp.hop')
local utils = require('test.utils')

describe('hop_to_reference', function()
    it('__hop_to_reference hops correctly', function()
        utils.prepare('test/sources/hop_to_reference.cs', 'test/sources/hop_to_reference.cs', 6, 21)

        hop.__hop_to_reference({ jump_on_quickfix = true })

        local buf = vim.api.nvim_get_current_buf()
        local name = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))

        assert(name:find('test/sources/hop_to_reference.cs$') ~= nil)
        local position = vim.fn.getcursorcharpos(0)
        assert(position[2] == 14)
        assert(position[3] == 13)
    end)

    it('__hop_to_reference hops from attribute defention to references', function()
        -- standing on AlfaAttribute defenition
        utils.prepare('test/sources/hop_to_reference.cs', 'test/sources/hop_to_reference.cs', 28, 26)

        local called = false
        hop.__hop_to_reference({
            callback = function(references)
                called = true

                assert(#references == 2)
                assert(references[1].name == 'Alfa')
                assert(references[1].path == 'test/sources/hop_to_reference.cs')
                assert(references[1].row == 4)
                assert(references[1].column == 9)

                assert(references[2].name == 'AlfaAttribute')
                assert(references[2].path == 'test/sources/hop_to_reference.cs')
                assert(references[2].row == 10)
                assert(references[2].column == 9)
            end,
        })

        assert(called)
    end)

    it('__hop_to_reference hops from attribute usage to references', function()
        utils.prepare('test/sources/hop_to_reference.cs', 'test/sources/hop_to_reference.cs', 11, 13)

        hop.__hop_to_reference({ jump_on_quickfix = true })

        local buf = vim.api.nvim_get_current_buf()
        local name = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))

        assert(name:find('test/sources/hop_to_reference.cs$') ~= nil)
        local position = vim.fn.getcursorcharpos(0)
        assert(position[2] == 5)
        assert(position[3] == 10)
    end)

    it('__hop_to_reference hops from class definition to references', function()
        utils.prepare('test/sources/hop_to_reference.cs', 'test/sources/Class2.cs', 5, 14)

        hop.__hop_to_reference({ jump_on_quickfix = true })

        local buf = vim.api.nvim_get_current_buf()
        local name = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))

        assert(name:find('test/sources/hop_to_reference.cs$') ~= nil)
        local position = vim.fn.getcursorcharpos(0)
        assert(position[2] == 18)
        assert(position[3] == 13)
    end)
end)
