local parse = require('hopcsharp.parse')

describe('parse', function()
    it('__get_sorce_files returns only cs files', function()
        for _, file in pairs(parse.__get_source_files()) do
            assert(file:find('.cs$') ~= nil)
        end
    end)

    it('__parse_tree parses file tree', function()
        local path = vim.fn.getcwd() .. '/test/sources/DummyClass1.cs'
        parse.__parse_tree(path, function(tree, file_content)
            assert(tree ~= nil)
            assert(file_content ~= nil)
        end)
    end)

    it('__get_classes retrieves data correctly', function()
        local path = vim.fn.getcwd() .. '/test/sources/DummyClass2.cs'
        parse.__parse_tree(path, function(tree, file_content)
            local classes = parse.__get_classes(tree:root(), file_content)
            assert(#classes == 2)
            assert(classes[1].name == 'DummyClass2')
            assert(classes[1].namespace == 'My.Very.Own.Namespace')
            assert(classes[1].start_column == 17)
            assert(classes[1].start_row == 4)

            assert(classes[2].name == 'DummiestClass2')
            assert(classes[2].namespace == 'My.Very.Own.Namespace')
            assert(classes[2].start_column == 17)
            assert(classes[2].start_row == 8)
        end)
    end)

end)

