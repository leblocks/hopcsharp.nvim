local tree = require('hopcsharp.hierarchy.tree')

describe('tree hiearchy tests', function()
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
            name = "node1",
            children = nil,
        }

        local lines = tree.__tree_to_lines(root, '-')
        assert(lines ~= nil)
        assert(#lines == 1)
        assert(lines[1] == 'node1')
    end)

    it('__tree_to_lines - happy path', function()
        local root = {
            name = "node1",
            children = {
                { name = "node2", children = {} },
                { name = "node3", children = {} },
            }
        }

        local lines = tree.__tree_to_lines(root, '-')
        assert(lines ~= nil)
        assert(#lines == 3)
        assert(lines[1] == 'node1')
        assert(lines[2] == '-node2')
        assert(lines[3] == '-node3')
    end)
end)
