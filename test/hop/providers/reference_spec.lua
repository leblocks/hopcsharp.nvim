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

    -- TODO complete other test cases
end)
