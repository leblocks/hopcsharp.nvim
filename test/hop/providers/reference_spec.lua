local test_utils = require('test.utils')
local providers = require('hopcsharp.hop.providers.reference')

describe('hop.providers.reference', function()
    it('__by_name_and_current_namespace (constructor_declaration) - can_handle is true', function()
        test_utils.prepare('test/sources/hop_to_reference.cs', 'test/sources/hop_to_reference.cs', 12, 16)
        local provider = providers.__by_name_and_current_namespace('doesntmatterfortest', vim.treesitter.get_node())
        assert(provider.can_handle())
    end)

    it('__by_name_and_current_namespace (class_declaration) - can_handle is true', function()
        test_utils.prepare('test/sources/hop_to_reference.cs', 'test/sources/hop_to_reference.cs', 28, 19)
        local provider = providers.__by_name_and_current_namespace('doesntmatterfortest', vim.treesitter.get_node())
        assert(provider.can_handle())
    end)

    it('__by_name_and_current_namespace (class_declaration) - can_handle is false', function()
        test_utils.prepare(
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            3,
            35
        )
        local provider = providers.__by_name_and_current_namespace('doesntmatterfortest', vim.treesitter.get_node())
        assert(not provider.can_handle())
    end)

    it('__by_name_and_current_namespace (record_declaration) - can_handle is false', function()
        test_utils.prepare(
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            30,
            28
        )
        local provider = providers.__by_name_and_current_namespace('doesntmatterfortest', vim.treesitter.get_node())
        assert(not provider.can_handle())
    end)

    it('__by_name_and_current_namespace (record_declaration) - can_handle is true', function()
        test_utils.prepare(
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            42,
            19
        )
        local provider = providers.__by_name_and_current_namespace('doesntmatterfortest', vim.treesitter.get_node())
        assert(provider.can_handle())
    end)

    it('__by_name_and_current_namespace (method_declaration) - can_handle is false', function()
        test_utils.prepare(
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            5,
            36
        )
        local provider = providers.__by_name_and_current_namespace('doesntmatterfortest', vim.treesitter.get_node())
        assert(not provider.can_handle())
    end)

    it('__by_name_and_current_namespace (method_declaration) - can_handle is true', function()
        test_utils.prepare(
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            10,
            28
        )
        local provider = providers.__by_name_and_current_namespace('doesntmatterfortest', vim.treesitter.get_node())
        assert(provider.can_handle())
    end)

    it('__by_name_and_current_namespace (interface_declaration) - can_handle is true', function()
        test_utils.prepare(
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            15,
            22
        )
        local provider = providers.__by_name_and_current_namespace('doesntmatterfortest', vim.treesitter.get_node())
        assert(provider.can_handle())
    end)

    it('__by_name_and_current_namespace (interface_declaration) - can_handle is false', function()
        test_utils.prepare(
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            38,
            24
        )
        local provider = providers.__by_name_and_current_namespace('doesntmatterfortest', vim.treesitter.get_node())
        assert(not provider.can_handle())
    end)

    it('__by_name_and_current_namespace (enum_declaration) - can_handle is false', function()
        test_utils.prepare(
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            46,
            19
        )
        local provider = providers.__by_name_and_current_namespace('doesntmatterfortest', vim.treesitter.get_node())
        assert(not provider.can_handle())
    end)

    it('__by_name_and_current_namespace (enum_declaration) - can_handle is true', function()
        test_utils.prepare(
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            23,
            18
        )
        local provider = providers.__by_name_and_current_namespace('doesntmatterfortest', vim.treesitter.get_node())
        assert(provider.can_handle())
    end)

    it('__by_name_and_current_namespace (struct_declaration) - can_handle is false', function()
        test_utils.prepare(
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            53,
            28
        )
        local provider = providers.__by_name_and_current_namespace('doesntmatterfortest', vim.treesitter.get_node())
        assert(not provider.can_handle())
    end)

    it('__by_name_and_current_namespace (struct_declaration) - can_handle is true', function()
        test_utils.prepare(
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            'test/sources/HopToReference/InternalModifier/MethodsWithInternalModifier.cs',
            19,
            19
        )
        local provider = providers.__by_name_and_current_namespace('doesntmatterfortest', vim.treesitter.get_node())
        assert(provider.can_handle())
    end)
end)
