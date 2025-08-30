local hierarchy = require('hopcsharp.hierarchy.utils')
local utils = require('hopcsharp.__test_utils')

describe('get_type_parents', function()
    it('__get_type_parents parses tree from type to parent type correctly - from a leaf', function()
        utils.prepare('test/sources/get_type_hierarchy.cs', 'test/sources/get_type_hierarchy.cs', 1, 1)

        local root = hierarchy.__get_type_parents('Class1Generation4')

        assert(root ~= nil)
        assert(root.name == 'Class1Generation1')
        assert(#root.children == 1)

        assert(root.children[1].name == 'Class1Generation2')
        assert(#root.children[1].children == 1)

        assert(root.children[1].children[1].name == 'Class1Generation3')
        assert(#root.children[1].children[1].children == 1)

        assert(root.children[1].children[1].children[1].name == 'Class1Generation4')
        assert(#root.children[1].children[1].children[1].children == 0)
    end)

    it('__get_type_parents parses tree from type to parent type correctly - from a middle node', function()
        utils.prepare('test/sources/get_type_hierarchy.cs', 'test/sources/get_type_hierarchy.cs', 1, 1)

        local root = hierarchy.__get_type_parents('Class1Generation3')

        assert(root ~= nil)
        assert(root.name == 'Class1Generation1')
        assert(#root.children == 1)

        assert(root.children[1].name == 'Class1Generation2')
        assert(#root.children[1].children == 1)

        assert(root.children[1].children[1].name == 'Class1Generation3')
        assert(#root.children[1].children[1].children == 0)
    end)

    it('__get_type_parents parses tree from type to parent type correctly - from root node', function()
        utils.prepare('test/sources/get_type_hierarchy.cs', 'test/sources/get_type_hierarchy.cs', 1, 1)

        local root = hierarchy.__get_type_parents('Class1Generation1')

        assert(root ~= nil)
        assert(root.name == 'Class1Generation1')
        assert(#root.children == 0)
    end)

    it('__get_type_parents parses tree from type to parent type correctly - non-existing node', function()
        utils.prepare('test/sources/get_type_hierarchy.cs', 'test/sources/get_type_hierarchy.cs', 1, 1)

        local root = hierarchy.__get_type_parents('DummyNonExistingNode')

        assert(root ~= nil)
        assert(root.name == 'DummyNonExistingNode')
        assert(#root.children == 0)
    end)
end)
