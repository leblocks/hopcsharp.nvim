local database = require('hopcsharp.database')

local M = {}

M.__get_source_files = function()
    local result = vim.system({ 'fd', '--extension', 'cs' },
        { text = true, cwd = vim.fn.getcwd(), }):wait()

    local files = {}

    for line in result.stdout:gmatch("([^\n]*)\n?") do
        if line ~= "" then
            table.insert(files, line)
        end
    end

    return files
end

M.__parse_tree = function(file_path, callback)
    local db = database.__get_db()
    local file, err = io.open(file_path, 'r')

    if not file then
        print('error opening ' .. file_path .. ' error: ' .. err)
        return
    end

    local file_content = file:read('*a')
    local parser = vim.treesitter.get_string_parser(file_content, "c_sharp", { error = false })

    if not parser then
        return
    end

    parser:parse(false, function(_, trees)
        if not trees then
            return
        end

        parser:for_each_tree(function(tree, _)
            callback(tree, file_path, file_content, db)
        end)
    end)

    file:close()
end

return M
