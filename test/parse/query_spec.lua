local query = require('hopcsharp.parse.query')

describe('parse.query', function()
    it('declaration identifier - enum', function()
        local content = [[
            namespace My.Test.Namespace;
            public enum Enum1 { One, Two, Three }
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, 'c_sharp', { error = false }))
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
        local parser = assert(vim.treesitter.get_string_parser(content, 'c_sharp', { error = false }))
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
        local parser = assert(vim.treesitter.get_string_parser(content, 'c_sharp', { error = false }))
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
        local parser = assert(vim.treesitter.get_string_parser(content, 'c_sharp', { error = false }))
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
        local parser = assert(vim.treesitter.get_string_parser(content, 'c_sharp', { error = false }))
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
        local parser = assert(vim.treesitter.get_string_parser(content, 'c_sharp', { error = false }))
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
        local parser = assert(vim.treesitter.get_string_parser(content, 'c_sharp', { error = false }))
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

    it('base identifier', function()
        local content = [[
            namespace My.Test.Namespace;
            public class Class1 : BaseClass1, BaseInterface1, BaseInterface2 {
                public Class1() {}
            }

            public interface Interface1 : BaseClass2, BaseInterface1, BaseInterface2 {
                public Class1() {}
            }

            public record Record1 : BaseClass2, BaseInterface1, BaseInterface2 {
                public Class1() {}
            }

            public struct Struct1 : BaseClass2, BaseInterface1, BaseInterface2 {
                public Class1() {}
            }
        ]]

        local parser = assert(vim.treesitter.get_string_parser(content, 'c_sharp', { error = false }))
        local inheritance = {}

        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, match, _ in query.base_identifier:iter_matches(tree:root(), content, 0, -1) do
                    local entry = {}
                    for id, nodes in pairs(match) do
                        local name = query.base_identifier.captures[id]
                        for _, node in ipairs(nodes) do
                            entry[name] = vim.treesitter.get_node_text(node, content, nil)
                        end
                    end
                    table.insert(inheritance, entry)
                end
            end)
        end)

        assert(#inheritance > 0)

        local actual = {}
        actual['Class1'] = 0
        actual['Struct1'] = 0
        actual['Record1'] = 0
        actual['Interface1'] = 0

        for _, entry in ipairs(inheritance) do
            for k, v in pairs(entry) do
                if k == 'name' then
                    if v == 'Class1' then
                        actual[v] = actual[v] + 1
                    elseif v == 'Struct1' then
                        actual[v] = actual[v] + 1
                    elseif v == 'Record1' then
                        actual[v] = actual[v] + 1
                    elseif v == 'Interface1' then
                        actual[v] = actual[v] + 1
                    end
                end
            end
        end

        assert(actual['Class1'] == 3)
        assert(actual['Struct1'] == 3)
        assert(actual['Record1'] == 3)
        assert(actual['Interface1'] == 3)
    end)

    it('reference - method invocation', function()
        local content = [[
            public class Test
            {
                public Test()
                {
                    Method1();
                }
            }
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, 'c_sharp', { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.reference:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'Method1')
                end
            end)
        end)
        assert(visited)
    end)

    it('reference - generic method invocation', function()
        local content = [[
            public class Test
            {
                public Test()
                {
                    Method1<Wow>();
                }
            }
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, 'c_sharp', { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.reference:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'Method1')
                end
            end)
        end)
        assert(visited)
    end)

    it('reference - method invocation inside lambda', function()
        local content = [[
            public class Test
            {
                public Test()
                {
                    var test = () => Method1());
                }
            }
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, 'c_sharp', { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.reference:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'Method1')
                end
            end)
        end)
        assert(visited)
    end)

    it('reference - method invocation inside member access expression', function()
        local content = [[
            public class Test
            {
                public Test()
                {
                    Class2.Method1();
                }
            }
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, 'c_sharp', { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.reference:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'Method1')
                end
            end)
        end)
        assert(visited)
    end)

    it('reference - generic method invocation inside member access expression', function()
        local content = [[
            public class Test
            {
                public Test()
                {
                    Class2.Method1<Test>();
                }
            }
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, 'c_sharp', { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.reference:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'Method1')
                end
            end)
        end)
        assert(visited)
    end)

    it('reference - generic method invocation inside generic member access expression', function()
        local content = [[
            public class Test
            {
                public Test()
                {
                    Class2<Sploof>.Method1<Test>();
                }
            }
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, 'c_sharp', { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.reference:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'Method1')
                end
            end)
        end)
        assert(visited)
    end)

    it('reference - variable declaration explicit type name', function()
        local content = [[
            public class Test
            {
                public Test()
                {
                    Class314 myClass = new();
                }
            }
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, 'c_sharp', { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.reference:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'Class314')
                end
            end)
        end)
        assert(visited)
    end)

    it('reference - generic variable declaration explicit type name', function()
        local content = [[
            public class Test
            {
                public Test()
                {
                    Class314<GenA, GenB> myClass = new();
                }
            }
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, 'c_sharp', { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.reference:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'Class314')
                end
            end)
        end)
        assert(visited)
    end)

    it('reference - object creation', function()
        local content = [[
            public class Test
            {
                public Test()
                {
                    var test = new VerySpecialClass();
                }
            }
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, 'c_sharp', { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.reference:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'VerySpecialClass')
                end
            end)
        end)
        assert(visited)
    end)

    it('reference - generic object creation', function()
        local content = [[
            public class Test
            {
                public Test()
                {
                    var test = new VerySpecialClass<GenA, GenB, GenZ>();
                }
            }
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, 'c_sharp', { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.reference:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'VerySpecialClass')
                end
            end)
        end)
        assert(visited)
    end)

    it('reference - attribute on a class', function()
        local content = [[
            [MyAttr]
            public class Test
            {
                public Test()
                {
                }
            }
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, 'c_sharp', { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.reference:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'MyAttr')
                end
            end)
        end)
        assert(visited)
    end)

    it('reference - attribute on a method', function()
        local content = [[
            public class Test
            {
                [MyAttr]
                void Method()
                {
                }
            }
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, 'c_sharp', { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.reference:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'MyAttr')
                end
            end)
        end)
        assert(visited)
    end)

    it('reference - attribute on an argument', function()
        local content = [[
            public class Test
            {
                void Method([MyAttr] int argument)
                {
                }
            }
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, 'c_sharp', { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.reference:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'MyAttr')
                end
            end)
        end)
        assert(visited)
    end)

    it('reference - types from ignore list are not captured', function()
        local content = [[
            public class Test
            {
                void Method([MyAttr] int argument)
                {
                    Task meow = GetNewTask();
                }
            }
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, 'c_sharp', { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.reference:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name ~= 'Task')
                end
            end)
        end)
        assert(visited)
    end)

    it('namespace - file scoped namespace', function()
        local content = [[
            namespace This.Is.My.Test;
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, 'c_sharp', { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.namespace_identifier:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'This.Is.My.Test')
                end
            end)
        end)
        assert(visited)
    end)

    it('namespace - namespace declaration', function()
        local content = [[
            namespace This.Is.My.Test
            {
            }
        ]]

        local visited = false
        local parser = assert(vim.treesitter.get_string_parser(content, 'c_sharp', { error = false }))
        parser:parse(false, function(_, trees)
            assert(trees)
            parser:for_each_tree(function(tree, _)
                assert(tree)
                for _, node, _, _ in query.namespace_identifier:iter_captures(tree:root(), content, 0, -1) do
                    local name = vim.treesitter.get_node_text(node, content, nil)
                    visited = true
                    assert(name == 'This.Is.My.Test')
                end
            end)
        end)
        assert(visited)
    end)
end)
