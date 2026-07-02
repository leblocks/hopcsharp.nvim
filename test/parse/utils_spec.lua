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

    it('__get_commit_hash', function()
        local commit_hash = utils.__get_commit_hash()
        assert(commit_hash ~= '')
        assert(commit_hash ~= nil)
    end)

    it('__get_changed_files -- no files changed', function()
        local files = utils.__get_changed_files('0a92195', '0a92105')
        assert(#files == 0)
    end)

    it('__get_changed_files -- only cs files reported', function()
        -- here only lua files were changed
        local files = utils.__get_changed_files(
            '065ee52f9a645d4d7d85823a375b44efe505a1a6',
            '88279b56355b5911521299a0431607936e13fe30'
        )
        assert(#files == 0)
    end)

    it('__get_changed_files -- happy path', function()
        local commit1 = 'e04b5b38d85e4c07b41c8cb737cb6d7bd6838073'
        local commit2 = '7515d034893f64d7151b7b13924bb1c2dbaa5c65'
        local files = utils.__get_changed_files(commit1, commit2)
        assert(#files == 6)
        assert(files[1] == 'test/sources/HopToReference/ByNameAndCurrentNamespace/Definition1.cs')
        assert(files[2] == 'test/sources/HopToReference/ByNameAndCurrentNamespace/Definition2.cs')
        assert(files[3] == 'test/sources/HopToReference/ByNameAndCurrentNamespace/ReferenceWithUsings1.cs')
        assert(files[4] == 'test/sources/HopToReference/ByNameAndCurrentNamespace/ReferenceWithUsings2.cs')
        assert(files[5] == 'test/sources/usings/FirstExample.cs')
        assert(files[6] == 'test/sources/usings/SecondExample.cs')
    end)
end)
