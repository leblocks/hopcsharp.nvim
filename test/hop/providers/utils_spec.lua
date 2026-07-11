local utils = require('hopcsharp.hop.providers.utils')
local test_utils = require('test.utils')
local database_utils = require('hopcsharp.database.utils')

describe('hop.providers.utils', function()
    it('__get_node_type - method definition', function()
        test_utils.prepare('test/sources/hop_to_reference.cs', 'test/sources/hop_to_reference.cs', 30, 22)
        local current_word, node_type = utils.__get_node_type(vim.fn.expand('<cword>'), vim.treesitter.get_node())
        assert(current_word == 'AlfaMethod')
        assert(node_type == nil)
    end)

    it('__get_node_type - attribute', function()
        test_utils.prepare('test/sources/hop_to_reference.cs', 'test/sources/hop_to_reference.cs', 5, 10)
        local current_word, node_type = utils.__get_node_type(vim.fn.expand('<cword>'), vim.treesitter.get_node())
        assert(current_word == 'AlfaAttribute')
        assert(node_type == database_utils.types.CLASS)
    end)

    it('__get_node_type - invocation_expression', function()
        test_utils.prepare('test/sources/hop_to_reference.cs', 'test/sources/hop_to_reference.cs', 14, 15)
        local current_word, node_type = utils.__get_node_type(vim.fn.expand('<cword>'), vim.treesitter.get_node())
        assert(current_word == 'Method1')
        assert(node_type == database_utils.types.METHOD)
    end)

    it('__get_node_modifiers - method', function()
        test_utils.prepare(
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            10,
            9
        )

        local modifiers = utils.__get_node_modifiers(vim.treesitter.get_node())
        table.sort(modifiers)
        assert(#modifiers == 2)
        assert(modifiers[1] == 'public')
        assert(modifiers[2] == 'static')
    end)

    it('__get_node_modifiers - local function statement', function()
        test_utils.prepare(
            'test/sources/HopToReference/InternalModifier/LocalFunctionStatement.cs',
            'test/sources/HopToReference/InternalModifier/LocalFunctionStatement.cs',
            1,
            28
        )

        local modifiers = utils.__get_node_modifiers(vim.treesitter.get_node())
        table.sort(modifiers)
        assert(#modifiers == 3)
        assert(modifiers[1] == 'async')
        assert(modifiers[2] == 'internal')
        assert(modifiers[3] == 'static')
    end)

    it('__get_node_modifiers - class', function()
        test_utils.prepare(
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            3,
            35
        )

        local modifiers = utils.__get_node_modifiers(vim.treesitter.get_node())
        table.sort(modifiers)
        assert(#modifiers == 3)
        assert(modifiers[1] == 'internal')
        assert(modifiers[2] == 'partial')
        assert(modifiers[3] == 'static')
    end)

    it('__get_node_modifiers - interface', function()
        test_utils.prepare(
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            15,
            22
        )

        local modifiers = utils.__get_node_modifiers(vim.treesitter.get_node())
        table.sort(modifiers)
        assert(#modifiers == 1)
        assert(modifiers[1] == 'public')
    end)

    it('__get_node_modifiers - struct', function()
        test_utils.prepare(
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            15,
            22
        )

        local modifiers = utils.__get_node_modifiers(vim.treesitter.get_node())
        assert(#modifiers == 1)
        assert(modifiers[1] == 'public')
    end)

    it('__get_node_modifiers - record', function()
        test_utils.prepare(
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            30,
            28
        )

        local modifiers = utils.__get_node_modifiers(vim.treesitter.get_node())
        table.sort(modifiers)
        assert(#modifiers == 2)
        assert(modifiers[1] == 'internal')
        assert(modifiers[2] == 'static')
    end)

    it('__get_node_modifiers - enum', function()
        test_utils.prepare(
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            23,
            18
        )

        local modifiers = utils.__get_node_modifiers(vim.treesitter.get_node())
        assert(#modifiers == 1)
        assert(modifiers[1] == 'private')
    end)

    it('__get_node_modifiers - empty', function()
        test_utils.prepare(
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            34,
            11
        )

        local modifiers = utils.__get_node_modifiers(vim.treesitter.get_node())
        assert(#modifiers == 0)
    end)
end)
