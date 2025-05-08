local query = require('hopcsharp.parse.query')


describe('parse.query', function()
    it('namesace query - regular', function()
        local content = [[
            namespace My.Test.Namespace {
                public class Class1 {}
            }
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, "c_sharp", { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.namespace:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'My.Test.Namespace')
                end
            end)
        end)
        assert(visited)
    end)

    it('namesace query - file scoped', function()
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
                for _, node, _, _ in query.namespace:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'My.Test.Namespace')
                end
            end)
        end)
        assert(visited)
    end)

    it('class identifier query', function()
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
                for _, node, _, _ in query.class_identifier:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'Class1')
                end
            end)
        end)
        assert(visited)
    end)

    it('class declaration query', function()
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
                for _, node, _, _ in query.class_declaration:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'public class Class1 {}')
                end
            end)
        end)
        assert(visited)
    end)

    it('interface identifier query', function()
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
                for _, node, _, _ in query.interface_identifier:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'IClass1')
                end
            end)
        end)
        assert(visited)
    end)

    it('interface declaration query', function()
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
                for _, node, _, _ in query.interface_declaration:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'public interface IClass1 {}')
                end
            end)
        end)
        assert(visited)
    end)

    it('enum declaration query', function()
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
                for _, node, _, _ in query.enum_declaration:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'public enum Enum1 { One, Two, Three }')
                end
            end)
        end)
        assert(visited)
    end)

    it('enum identifier query', function()
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
                for _, node, _, _ in query.enum_identifier:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'Enum1')
                end
            end)
        end)
        assert(visited)
    end)

    it('struct declaration query', function()
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
                for _, node, _, _ in query.struct_declaration:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'public struct Struct1 {}')
                end
            end)
        end)
        assert(visited)
    end)

    it('struct identifier query', function()
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
                for _, node, _, _ in query.struct_identifier:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'Struct1')
                end
            end)
        end)
        assert(visited)
    end)

    it('record declaration query', function()
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
                for _, node, _, _ in query.record_declaration:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'public record Record1 {}')
                end
            end)
        end)
        assert(visited)
    end)

    it('record identifier query', function()
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
                for _, node, _, _ in query.record_identifier:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'Record1')
                end
            end)
        end)
        assert(visited)
    end)

    it('method declaration query', function()
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
                for _, node, _, _ in query.method_declaration:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'public int Foo() {}')
                end
            end)
        end)
        assert(visited)
    end)

    it('method identifier query', function()
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
                for _, node, _, _ in query.method_identifier:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'Foo')
                end
            end)
        end)
        assert(visited)
    end)

    it('constructor declaration query', function()
        local content = [[
            namespace My.Test.Namespace;
            public class Class1 {
                public Class1() {}
            }
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, "c_sharp", { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                for _, node, _, _ in query.constructor_declaration:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'public Class1() {}')
                end
            end)
        end)
        assert(visited)
    end)

    it('constructor identifier query', function()
        local content = [[
            namespace My.Test.Namespace;
            public class Class1 {
                public Class1() {}
            }
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, "c_sharp", { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.constructor_identifier:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'Class1')
                end
            end)
        end)
        assert(visited)
    end)
end)
