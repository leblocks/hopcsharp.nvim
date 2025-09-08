local tree = require('hopcsharp.hierarchy.tree')

describe('tree hiearchy tests', function()
    it('__create_node - nil children', function()
        local node = tree.__create_node('test', nil)
        assert(node.name == 'test')
        assert(node.children ~= nil)
        assert(#node.children == 0)
    end)

    it('__create_node - with children', function()
        local node = tree.__create_node('test', { tree.__create_node('child') })
        assert(node.name == 'test')
        assert(#node.children == 1)
        assert(node.children[1].name == 'child')
    end)

    it('__tree_to_lines - empty tree does not fail', function()
        local lines = tree.__tree_to_lines({}, '-')
        assert(#lines == 0)
    end)

    it('__tree_to_lines - nil tree does not fail', function()
        local lines = tree.__tree_to_lines(nil, '-')
        assert(#lines == 0)
    end)

    it('__tree_to_lines - nil children does not fail', function()
        local root = {
            name = 'node1',
            children = nil,
        }

        local lines = tree.__tree_to_lines(root, '-')
        assert(lines ~= nil)
        assert(#lines == 1)
        assert(lines[1] == 'node1')
    end)

    it('__tree_to_lines - happy path', function()
        local root = {
            name = 'node1',
            children = {
                { name = 'node2', children = {} },
                { name = 'node3', children = {} },
            },
        }

        local lines = tree.__tree_to_lines(root, '-')
        assert(lines ~= nil)
        assert(#lines == 3)
        assert(lines[1] == 'node1')
        assert(lines[2] == '-node2')
        assert(lines[3] == '-node3')
    end)

    it('__get_leaf_nodes - happy path', function()
        local root = {
            name = 'node1',
            children = {
                { name = 'node2', children = {} },
                { name = 'node3', children = {} },
            },
        }

        local leafs = tree.__get_leaf_nodes(root)
        assert(leafs ~= nil)
        assert(#leafs == 2)
        assert(leafs[1] == 'node2')
        assert(leafs[2] == 'node3')
    end)

    it('__get_leaf_nodes - nil tree does not fail', function()
        local leafs = tree.__get_leaf_nodes(nil)
        assert(leafs ~= nil)
        assert(#leafs == 0)
    end)

    it('__get_leaf_nodes - nil children does not fail', function()
        local root = {
            name = 'test',
            childnren = nil,
        }

        local leafs = tree.__get_leaf_nodes(root)
        assert(leafs ~= nil)
        assert(#leafs == 1)
        assert(leafs[1] == 'test')
    end)

    it('__get_leaf_nodes - empty children does not fail', function()
        local root = {
            name = 'test',
            children = {},
        }

        local leafs = tree.__get_leaf_nodes(root)
        assert(leafs ~= nil)
        assert(#leafs == 1)
        assert(leafs[1] == 'test')
    end)

    it('__get_leaf_nodes - happy path', function()
        local root = {
            name = 'test',
            children = {
                { name = 'leaf1', children = {} },
                {
                    name = 'meow',
                    children = {
                        { name = 'leaf2', children = {} },
                    },
                },
            },
        }

        local leafs = tree.__get_leaf_nodes(root)
        assert(leafs ~= nil)
        assert(#leafs == 2)
        assert(leafs[1] == 'leaf1')
        assert(leafs[2] == 'leaf2')
    end)
end)
