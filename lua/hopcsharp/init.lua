local db = require('hopcsharp.db')
local parse = require('hopcsharp.parse')

local M = {}

M.init_database = function()
    local files = parse.__get_source_files()
    local _db = db.__get_db()

    -- TODO refactor out
    for _, file in ipairs(files) do
        parse.__parse_tree(file, function(tree, file_content)
            local classes = parse.__get_classes(tree:root(), file_content)

            for _, class in ipairs(classes) do
                _db:with_open(function()
                    _db:eval(
                        [[insert into classes values (:file_path, :namespace, :name, :start_row, :start_column)]],
                        {
                            file_path = file,
                            namespace = class.namespace,
                            name = class.name,
                            start_row = class.start_row,
                            start_column = class.start_column
                        })
                end)
            end
        end)
    end
end

M.goto_definition = function()
end

M.goto_reference = function()
end

return M
