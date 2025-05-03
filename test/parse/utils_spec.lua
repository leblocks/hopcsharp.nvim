local query = require('hopcsharp.parse.query')
local utils = require('hopcsharp.parse.utils')

describe('parse.utils', function()
    it('get_query can be called', function()
        local query = utils.get_query('(class_declaration) @class')
        assert(query)
    end)

    it('icaptures can be called', function()
        local content = [[
            namespace My.Test.Namespace {
                public class Class1 {}
            }
        ]]

        local parser = assert(vim.treesitter.get_string_parser(content, "c_sharp", { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                utils.icaptures(query.namespace, tree:root(), content, function(node, c)
                    local name = vim.treesitter.get_node_text(node, c, nil)
                    assert(name == 'My.Test.Namespace')
                end)
            end)
        end)
    end)
end)
