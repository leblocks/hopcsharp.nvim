local Job = require('plenary.job')
local context = require('plenary.context_manager')
local database = require('hopcsharp.db')

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

local NAMESPACE_QUERY = get_query('([(namespace_declaration (qualified_name) @name)(file_scoped_namespace_declaration (qualified_name) @name)])')

local CLASS_DECLARATION_QUERY = get_query('(class_declaration) @class')
local CLASS_IDENTIFIER_QUERY = get_query('(class_declaration (identifier) @name)')


M.__get_source_files = function()
    local files = {}
    ---@diagnostic disable-next-line: missing-fields
    Job:new({
        command = 'fd',
        args = { '--extension', 'cs' },
        cwd = vim.fn.getcwd(),

        on_stderr = function(err, data)
            error('fd --extension cs failed with: ' .. err .. ' ' .. data)
        end,

        on_stdout = function(err, data)
            table.insert(files, data)
        end,

    }):sync()

    return files
end

-- TODO skip trees with errors?
M.__parse_tree = function(file_path, callback)
    local db = database.__get_db()
    context.with(context.open(file_path), function(reader)
        local file_content = reader:read('*a')
        local parser = vim.treesitter.get_string_parser(file_content, "c_sharp", { error = false })
        parser:parse(false, function(_, trees)
            parser:for_each_tree(function(tree, ltree)
                callback(tree, file_path, file_content, db)
            end)
        end)
    end)
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

    icaptures(CLASS_DECLARATION_QUERY, tree, file_content, function(node, content)
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
