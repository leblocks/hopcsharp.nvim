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

    it('connect_parent_and_child_hierarchies - empty hierarchies', function()
        utils.prepare('test/sources/get_type_hierarchy.cs', 'test/sources/get_type_hierarchy.cs', 1, 1)

        local parents = hierarchy.__get_type_parents('test')
        local children = hierarchy.__get_type_children('test')

        hierarchy.__connect_parent_and_child_hierarchies(parents, children)

        assert(parents ~= nil)
        assert(parents.name == 'test')
        assert(#parents.children == 0)
    end)

    it('connect_parent_and_child_hierarchies - connection in the top', function()
        utils.prepare('test/sources/get_type_hierarchy.cs', 'test/sources/get_type_hierarchy.cs', 1, 1)

        local parents = hierarchy.__get_type_parents('Class1Generation1')
        local children = hierarchy.__get_type_children('Class1Generation1')

        hierarchy.__connect_parent_and_child_hierarchies(parents, children)

        assert(parents ~= nil)
        assert(parents.name == 'Class1Generation1')
        assert(#parents.children == 2)

        assert(parents.children[1].name == 'Class1Generation2')
        assert(#parents.children[1].children == 1)

        assert(parents.children[2].name == 'Class2Generation2')
        assert(#parents.children[2].children == 0)

        assert(parents.children[1].children[1].name == 'Class1Generation3')
        assert(#parents.children[1].children[1].children == 2)

        assert(parents.children[1].children[1].children[1].name == 'Class1Generation4')
        assert(#parents.children[1].children[1].children[1].children == 0)

        assert(parents.children[1].children[1].children[2].name == 'Class2Generation4')
        assert(#parents.children[1].children[1].children[2].children == 0)
    end)

    it('connect_parent_and_child_hierarchies - connection is in the bottom', function()
        utils.prepare('test/sources/get_type_hierarchy.cs', 'test/sources/get_type_hierarchy.cs', 1, 1)

        local parents = hierarchy.__get_type_parents('Class2Generation4')
        local children = hierarchy.__get_type_children('Class2Generation4')

        hierarchy.__connect_parent_and_child_hierarchies(parents, children)

        assert(parents ~= nil)
        assert(parents.name == 'Class1Generation1')
        assert(#parents.children == 1)

        assert(parents.children[1].name == 'Class1Generation2')
        assert(#parents.children[1].children == 1)

        assert(parents.children[1].children[1].name == 'Class1Generation3')
        assert(#parents.children[1].children[1].children == 1)

        assert(parents.children[1].children[1].children[1].name == 'Class2Generation4')
        assert(#parents.children[1].children[1].children[1].children == 0)
    end)

    it('connect_parent_and_child_hierarchies - no connection', function()
        utils.prepare('test/sources/get_type_hierarchy.cs', 'test/sources/get_type_hierarchy.cs', 1, 1)

        local parents = hierarchy.__get_type_parents('Class1Generation4')
        local children = hierarchy.__get_type_children('Class2Generation4')

        local success, _ = pcall(function()
            hierarchy.__connect_parent_and_child_hierarchies(parents, children)
        end)

        if success then
            -- call must not pass
            assert(false)
        else
            -- call must fail
            assert(true)
        end
    end)
end)
