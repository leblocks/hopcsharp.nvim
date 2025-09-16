local hierarchy = require('hopcsharp.hierarchy.utils')
local utils = require('test.utils')

describe('get_type_children', function()
    it('__get_type_children parses tree from type to children type correctly - from a root', function()
        utils.prepare('test/sources/get_type_hierarchy.cs', 'test/sources/get_type_hierarchy.cs', 1, 1)

        local root = hierarchy.__get_type_children('Class1Generation1')

        assert(root ~= nil)
        assert(root.name == 'Class1Generation1')
        assert(#root.children == 2)

        assert(root.children[1].name == 'Class1Generation2')
        assert(#root.children[1].children == 1)

        assert(root.children[2].name == 'Class2Generation2')
        assert(#root.children[2].children == 0)

        assert(root.children[1].children[1].name == 'Class1Generation3')
        assert(#root.children[1].children[1].children == 2)

        assert(root.children[1].children[1].children[1].name == 'Class1Generation4')
        assert(#root.children[1].children[1].children[1].children == 0)

        assert(root.children[1].children[1].children[2].name == 'Class2Generation4')
        assert(#root.children[1].children[1].children[2].children == 0)
    end)

    it('__get_type_children parses tree from type to children type correctly - from a leaf node', function()
        utils.prepare('test/sources/get_type_hierarchy.cs', 'test/sources/get_type_hierarchy.cs', 1, 1)

        local root = hierarchy.__get_type_children('Class2Generation2')

        assert(root ~= nil)
        assert(root.name == 'Class2Generation2')
        assert(#root.children == 0)
    end)

    it('__get_type_children parses tree from type to children type correctly - from a non-existing node', function()
        utils.prepare('test/sources/get_type_hierarchy.cs', 'test/sources/get_type_hierarchy.cs', 1, 1)

        local root = hierarchy.__get_type_children('Meow')

        assert(root ~= nil)
        assert(root.name == 'Meow')
        assert(#root.children == 0)
    end)

    it('__get_type_children parses tree from type to children type correctly - from a non-leaf node', function()
        utils.prepare('test/sources/get_type_hierarchy.cs', 'test/sources/get_type_hierarchy.cs', 1, 1)

        local root = hierarchy.__get_type_children('Class1Generation3')

        assert(root ~= nil)
        assert(root.name == 'Class1Generation3')
        assert(#root.children == 2)

        assert(root.children[1].name == 'Class1Generation4')
        assert(#root.children[1].children == 0)

        assert(root.children[2].name == 'Class2Generation4')
        assert(#root.children[2].children == 0)
    end)

    it(
        '__get_type_children parses tree from type to children type correctly - generic nodes - from root node',
        function()
            utils.prepare('test/sources/get_type_hierarchy.cs', 'test/sources/get_type_hierarchy.cs', 1, 1)

            local root = hierarchy.__get_type_children('Parent')

            assert(root ~= nil)
            assert(root.name == 'Parent')
            assert(#root.children == 1)

            assert(root.children[1].name == 'GenericParent<T>')
            assert(#root.children[1].children == 3)

            assert(root.children[1].children[1].name == 'Child<T,V,Z>')
            assert(#root.children[1].children[1].children == 0)

            assert(root.children[1].children[2].name == 'Child<T,V>')
            assert(#root.children[1].children[2].children == 0)

            assert(root.children[1].children[3].name == 'Child<T>')
            assert(#root.children[1].children[3].children == 0)
        end
    )

    it(
        '__get_type_children parses tree from type to children type correctly - generic nodes - from leaf node',
        function()
            utils.prepare('test/sources/get_type_hierarchy.cs', 'test/sources/get_type_hierarchy.cs', 1, 1)

            local root = hierarchy.__get_type_children('Child<T>')

            assert(root ~= nil)
            assert(root.name == 'Child<T>')
            assert(#root.children == 0)
        end
    )
end)
