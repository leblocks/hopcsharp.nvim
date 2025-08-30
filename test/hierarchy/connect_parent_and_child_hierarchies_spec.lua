local hierarchy = require('hopcsharp.hierarchy.utils')
local utils = require('test.utils')

describe('connect_parent_and_child_hierarchies', function()
    it('connect_parent_and_child_hierarchies - connection in the middle', function()
        utils.prepare('test/sources/get_type_hierarchy.cs', 'test/sources/get_type_hierarchy.cs', 1, 1)

        local parents = hierarchy.__get_type_parents('Class1Generation2')
        local children = hierarchy.__get_type_children('Class1Generation2')

        hierarchy.__connect_parent_and_child_hierarchies(parents, children)

        assert(parents ~= nil)
        assert(parents.name == 'Class1Generation1')
        assert(#parents.children == 1)

        assert(parents.children[1].name == 'Class1Generation2')
        assert(#parents.children[1].children == 1)

        assert(parents.children[1].children[1].name == 'Class1Generation3')
        assert(#parents.children[1].children[1].children == 2)

        assert(parents.children[1].children[1].children[1].name == 'Class1Generation4')
        assert(#parents.children[1].children[1].children[1].children == 0)

        assert(parents.children[1].children[1].children[2].name == 'Class2Generation4')
        assert(#parents.children[1].children[1].children[2].children == 0)
    end)
end)
