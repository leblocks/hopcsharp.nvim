local database = require('hopcsharp.database')

local M = {}


local function get_query(query)
    return vim.treesitter.query.parse('c_sharp', query)
end

---@param query vim.treesitter.Query
---@param tree TSNode
---@param file_content string
---@param callback function
local function icaptures(query, tree, file_content, callback)
    for _, node, _, _ in query:iter_captures(tree, file_content, 0, -1) do
        callback(node, file_content)
    end
end

local NAMESPACE_QUERY = get_query([[(
    [(namespace_declaration (qualified_name) @name)(file_scoped_namespace_declaration (qualified_name) @name)])
]])

local CLASS_DECLARATION_QUERY = get_query('(class_declaration) @class')
local CLASS_IDENTIFIER_QUERY = get_query('(class_declaration (identifier) @name)')


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
            if tree:root():has_error() then
                return
            end

            callback(tree, file_path, file_content, db)
        end)
    end)

    file:close()
end

---@param tree TSNode under which the search will occur
---@param file_path string file path
---@param file_content string file content
---@param db sqlite_db db object
M.__parse_classes = function(tree, file_path, file_content, db)
    local namespace_id = nil
    local file_path_id = database.__insert_file(db, file_path)

    icaptures(NAMESPACE_QUERY, tree, file_content, function(node, content)
        local name = vim.treesitter.get_node_text(node, content, nil)
        namespace_id = database.__insert_namespace(db, name)
    end)

    icaptures(CLASS_DECLARATION_QUERY, tree, file_content,
        function(node, content)
            icaptures(CLASS_IDENTIFIER_QUERY, node, content, function(n, c)
                local start_row, start_column, _, _ = n:range()
                db:insert('classes', {
                    file_path_id = file_path_id,
                    namespace_id = namespace_id,
                    name = vim.treesitter.get_node_text(n, c, nil),
                    start_row = start_row,
                    start_column = start_column,
                })
            end)
        end)
end

return M
