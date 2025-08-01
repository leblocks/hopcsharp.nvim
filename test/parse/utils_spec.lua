local query = require('hopcsharp.parse.query')
local utils = require('hopcsharp.parse.utils')

describe('parse.utils', function()
    it('get_query can be called', function()
        local _query = utils.__get_query('(class_declaration) @class')
        assert(_query)
    end)

    it('icaptures can be called', function()
        local content = [[
            namespace My.Test.Namespace {
                public class Class1 {}
            }
        ]]

        local parser = assert(vim.treesitter.get_string_parser(content, 'c_sharp', { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                utils.__icaptures(query.declaration_identifier, tree:root(), content, function(node, c)
                    local name = vim.treesitter.get_node_text(node, c, nil)
                    assert(name == 'Class1')
                end)
            end)
        end)
    end)
end)
