local query = require('hopcsharp.parse.query')


describe('parse.query', function()
    it('declaration identifier - enum', function()
        local content = [[
            namespace My.Test.Namespace;
            public enum Enum1 { One, Two, Three }
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, "c_sharp", { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.declaration_identifier:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'Enum1')
                end
            end)
        end)
        assert(visited)
    end)

    it('declaration identifier - class', function()
        local content = [[
            namespace My.Test.Namespace;
            public class Class1 {}
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, "c_sharp", { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.declaration_identifier:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'Class1')
                end
            end)
        end)
        assert(visited)
    end)

    it('declaration identifier - interface', function()
        local content = [[
            namespace My.Test.Namespace;
            public interface IClass1 {}
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, "c_sharp", { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.declaration_identifier:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'IClass1')
                end
            end)
        end)
        assert(visited)
    end)

    it('declaration identifier - struct', function()
        local content = [[
            namespace My.Test.Namespace;
            public struct Struct1 {}
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, "c_sharp", { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.declaration_identifier:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'Struct1')
                end
            end)
        end)
        assert(visited)
    end)

    it('declaration identifier - record', function()
        local content = [[
            namespace My.Test.Namespace;
            public record Record1 {}
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, "c_sharp", { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.declaration_identifier:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'Record1')
                end
            end)
        end)
        assert(visited)
    end)

    it('declaration identifier - method', function()
        local content = [[
            namespace My.Test.Namespace;
            public class Class1 {
                public int Foo() {}
            }
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, "c_sharp", { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.declaration_identifier:iter_captures(tree:root(), content, 0, -1) do
                    if node:parent():type() == 'method_declaration' then
                        local name = vim.treesitter.get_node_text(node, content, nil)
                        visited = true
                        assert(name == 'Foo')
                    end
                end
            end)
        end)
        assert(visited)
    end)

    it('declaration identifier - constructor', function()
        local content = [[
            namespace My.Test.Namespace;
            public class Class1 {
                public Class1() {}
            }
        ]]

        local visited_count = 0
        local parser = assert(vim.treesitter.get_string_parser(content, "c_sharp", { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.declaration_identifier:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    assert(name == 'Class1')
                    visited_count = visited_count + 1
                end
            end)
        end)
        assert(visited_count == 2)
    end)
end)
