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

    it('__hop_to_reference hops correctly considering used namespaces - 1', function()
        local files_to_parse = {
            'test/sources/HopToReference/ByNameAndCurrentNamespace/Definition1.cs',
            'test/sources/HopToReference/ByNameAndCurrentNamespace/Definition2.cs',
            'test/sources/HopToReference/ByNameAndCurrentNamespace/ReferenceWithUsings1.cs',
            'test/sources/HopToReference/ByNameAndCurrentNamespace/ReferenceWithUsings2.cs',
        }

        utils.prepare_multiple(files_to_parse, files_to_parse[1], 4, 14)

        hop.__hop_to_reference({ jump_on_quickfix = true })

        local buf = vim.api.nvim_get_current_buf()
        local name = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))

        assert(name:find('test/sources/HopToReference/ByNameAndCurrentNamespace/ReferenceWithUsings1.cs$') ~= nil)
        local position = vim.fn.getcursorcharpos(0)
        assert(position[2] == 9)
        assert(position[3] == 25)
    end)

    it('__hop_to_reference hops correctly considering used namespaces - 2', function()
        local files_to_parse = {
            'test/sources/HopToReference/ByNameAndCurrentNamespace/Definition1.cs',
            'test/sources/HopToReference/ByNameAndCurrentNamespace/Definition2.cs',
            'test/sources/HopToReference/ByNameAndCurrentNamespace/ReferenceWithUsings1.cs',
            'test/sources/HopToReference/ByNameAndCurrentNamespace/ReferenceWithUsings2.cs',
        }

        utils.prepare_multiple(files_to_parse, files_to_parse[2], 4, 14)

        hop.__hop_to_reference({ jump_on_quickfix = true })

        local buf = vim.api.nvim_get_current_buf()
        local name = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))

        assert(name:find('test/sources/HopToReference/ByNameAndCurrentNamespace/ReferenceWithUsings2.cs$') ~= nil)
        local position = vim.fn.getcursorcharpos(0)
        assert(position[2] == 9)
        assert(position[3] == 25)
    end)

    it('__hop_to_reference hops correctly considering used namespaces - 2 (file is in the same namespace)', function()
        local files_to_parse = {
            'test/sources/HopToReference/ByNameAndCurrentNamespace/Definition1.cs',
            'test/sources/HopToReference/ByNameAndCurrentNamespace/Definition2.cs',
            'test/sources/HopToReference/ByNameAndCurrentNamespace/Definition3.cs',
            'test/sources/HopToReference/ByNameAndCurrentNamespace/ReferenceWithUsings1.cs',
            'test/sources/HopToReference/ByNameAndCurrentNamespace/ReferenceWithUsings2.cs',
            'test/sources/HopToReference/ByNameAndCurrentNamespace/ReferenceWithSameNamespace.cs',
        }

        utils.prepare_multiple(files_to_parse, files_to_parse[3], 4, 14)

        hop.__hop_to_reference({ jump_on_quickfix = true })

        local buf = vim.api.nvim_get_current_buf()
        local name = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))

        assert(name:find('test/sources/HopToReference/ByNameAndCurrentNamespace/ReferenceWithSameNamespace.cs$') ~= nil)
        local position = vim.fn.getcursorcharpos(0)
        assert(position[2] == 8)
        assert(position[3] == 25)
    end)

    it('__hop_to_reference hops correctly to references in nested namespaces - (Outer to Middle)', function()
        local files_to_parse = {
            'test/sources/HopToReference/NestedNamespaces/Outer/Outer.cs',
            'test/sources/HopToReference/NestedNamespaces/AnotherOuter/AnotherOuter.cs',
            'test/sources/HopToReference/NestedNamespaces/AnotherOuter/Middle/Middle.cs',
            'test/sources/HopToReference/NestedNamespaces/Outer/Middle/Middle.cs',
            'test/sources/HopToReference/NestedNamespaces/Outer/Middle/Nested/Nested.cs',
        }

        utils.prepare_multiple(files_to_parse, files_to_parse[1], 4, 18)

        -- must find reference from Outer to Middle and from Outer to Nested
        hop.__hop_to_reference({ jump_on_quickfix = true })

        local buf = vim.api.nvim_get_current_buf()
        local name = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))

        assert(name:find('test/sources/HopToReference/NestedNamespaces/Outer/Middle/Middle.cs$') ~= nil)
        local position = vim.fn.getcursorcharpos(0)
        assert(position[2] == 8)
        assert(position[3] == 39)
    end)

    it('__hop_to_reference hops correctly to references in nested namespaces - (Middle to Nested)', function()
        local files_to_parse = {
            'test/sources/HopToReference/NestedNamespaces/Outer/Outer.cs',
            'test/sources/HopToReference/NestedNamespaces/AnotherOuter/AnotherOuter.cs',
            'test/sources/HopToReference/NestedNamespaces/AnotherOuter/Middle/Middle.cs',
            'test/sources/HopToReference/NestedNamespaces/Outer/Middle/Middle.cs',
            'test/sources/HopToReference/NestedNamespaces/Outer/Middle/Nested/Nested.cs',
        }

        utils.prepare_multiple(files_to_parse, files_to_parse[3], 12, 18)

        -- must find reference from Outer to Middle and from Outer to Nested
        hop.__hop_to_reference({ jump_on_quickfix = true })

        local buf = vim.api.nvim_get_current_buf()
        local name = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))

        assert(name:find('test/sources/HopToReference/NestedNamespaces/Outer/Middle/Nested/Nested.cs$') ~= nil)
        local position = vim.fn.getcursorcharpos(0)
        assert(position[2] == 8)
        assert(position[3] == 40)
    end)

    it(
        '__hop_to_reference hops correctly to references in nested namespaces - (AnotherOuter to AnotherOuter.Middle)',
        function()
            local files_to_parse = {
                'test/sources/HopToReference/NestedNamespaces/Outer/Outer.cs',
                'test/sources/HopToReference/NestedNamespaces/AnotherOuter/AnotherOuter.cs',
                'test/sources/HopToReference/NestedNamespaces/AnotherOuter/Middle/Middle.cs',
                'test/sources/HopToReference/NestedNamespaces/Outer/Middle/Middle.cs',
                'test/sources/HopToReference/NestedNamespaces/Outer/Middle/Nested/Nested.cs',
            }

            utils.prepare_multiple(files_to_parse, files_to_parse[2], 4, 18)

            -- must find reference from Outer to Middle and from Outer to Nested
            hop.__hop_to_reference({ jump_on_quickfix = true })

            local buf = vim.api.nvim_get_current_buf()
            local name = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))

            assert(name:find('test/sources/HopToReference/NestedNamespaces/AnotherOuter/Middle/Middle.cs$') ~= nil)
            local position = vim.fn.getcursorcharpos(0)
            assert(position[2] == 8)
            assert(position[3] == 39)
        end
    )
end)
