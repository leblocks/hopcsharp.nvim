local hierarchy = require('hopcsharp.hierarchy')
local utils = require('hopcsharp.__test_utils')

describe('get_type_children', function()
    it('__get_type_children parses tree from type to children type correctly - from a root', function()
        utils.prepare('test/sources/get_type_hierarchy.cs', 'test/sources/get_type_hierarchy.cs', 1, 1)

        local root = hierarchy.__get_type_children('Class1Generation1')

        print(vim.inspect(root))

        assert(root ~= nil)
        assert(root.name == 'Class1Generation1')
        assert(#root.children == 2)

        assert(root.children[1].name == 'Class1Generation2')
        assert(#root.children[1].children == 1)

        assert(root.children[2].name == 'Class2Generation2')
        assert(#root.children[2].children == 0)

        -- TODO finish assertions here
        assert(root.children[1].children[1].name == 'Class1Generation3')
        assert(#root.children[1].children[1].children == 2)

        assert(root.children[1].children[1].children[1].name == 'Class1Generation4')
        assert(#root.children[1].children[1].children[1].children == 0)

        assert(root.children[1].children[1].children[2].name == 'Class2Generation4')
        assert(#root.children[1].children[1].children[2].children == 0)
    end)

    -- TODO bad node name
    -- TODO leaf node
    -- TODO non-root node and non-leaf node
end)
