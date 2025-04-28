local parse = require('hopcsharp.parse')

local M = {}

M.init_database = function()
    local files = parse.__get_source_files()

    for _, file in ipairs(files) do
        parse.__parse_tree(file, function(tree, file_path, file_content, db)
            parse.__parse_classes(tree:root(), file_path, file_content, db)
        end)
    end
end

M.goto_definition = function()
end

M.goto_reference = function()
end

return M
