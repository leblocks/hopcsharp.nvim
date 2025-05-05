local query = require('hopcsharp.parse.query')


describe('parse.query', function()
    it('namesace query - regular', function()
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
                for _, node, _, _ in query.namespace:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    assert(name == 'My.Test.Namespace')
                end
            end)
        end)
    end)

    it('namesace query - file scoped', function()
        local content = [[
            namespace My.Test.Namespace;
            public class Class1 {}
        ]]

        local parser = assert(vim.treesitter.get_string_parser(content, "c_sharp", { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.namespace:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    assert(name == 'My.Test.Namespace')
                end
            end)
        end)
    end)

    it('class identifier query', function()
        local content = [[
            namespace My.Test.Namespace;
            public class Class1 {}
        ]]

        local parser = assert(vim.treesitter.get_string_parser(content, "c_sharp", { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.class_identifier:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    assert(name == 'Class1')
                end
            end)
        end)
    end)

    it('class declaration query', function()
        local content = [[
            namespace My.Test.Namespace;
            public class Class1 {}
        ]]

        local parser = assert(vim.treesitter.get_string_parser(content, "c_sharp", { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.class_declaration:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    assert(name == 'public class Class1 {}')
                end
            end)
        end)
    end)

    it('interface identifier query', function()
        local content = [[
            namespace My.Test.Namespace;
            public interface IClass1 {}
        ]]

        local parser = assert(vim.treesitter.get_string_parser(content, "c_sharp", { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.interface_identifier:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    assert(name == 'IClass1')
                end
            end)
        end)
    end)

    it('interface declaration query', function()
        local content = [[
            namespace My.Test.Namespace;
            public interface IClass1 {}
        ]]

        local parser = assert(vim.treesitter.get_string_parser(content, "c_sharp", { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.class_declaration:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    assert(name == 'public interface IClass1 {}')
                end
            end)
        end)
    end)

    it('enum declaration query', function()
        local content = [[
            namespace My.Test.Namespace;
            public enum Enum1 { One, Two, Three }
        ]]

        local parser = assert(vim.treesitter.get_string_parser(content, "c_sharp", { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.enum_declaration:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    assert(name == 'public enum Enum1 { One, Two, Three }')
                end
            end)
        end)
    end)

    it('enum identifier query', function()
        local content = [[
            namespace My.Test.Namespace;
            public enum Enum1 { One, Two, Three }
        ]]

        local parser = assert(vim.treesitter.get_string_parser(content, "c_sharp", { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.enum_identifier:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    print(name)
                    assert(name == 'Enum1')
                end
            end)
        end)
    end)
end)
