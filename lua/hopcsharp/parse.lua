local Job = require('plenary.job')
local context = require('plenary.context_manager')
local database = require('hopcsharp.db')

local M = {}


local function get_query(query)
    return vim.treesitter.query.parse('c_sharp', query)
end

---@param db sqlite_db db object
---@param name string namespace name
---@return integer id of inserted namespace
local function insert_namespace(db, name)
    -- TODO
end

---@param db sqlite_db db object
---@param file_path string file path
---@return integer id of inserted file_path
local function insert_file_path(db, file_path)
    -- TODO
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
    local db = P(database.__get_db())
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
    local file_path_id = nil

    local success, id = db:insert('files', { file_path = file_path })

    if success then
        file_path_id = id
    end

    for _, node, _, _ in NAMESPACE_QUERY:iter_captures(tree, file_content, 0, -1) do
        local name = vim.treesitter.get_node_text(node, file_content, nil)
        success, id = db:insert('namespaces', { name = name })
        if success then
            namespace_id = id
        end
    end

    for _, node, _, _ in CLASS_DECLARATION_QUERY:iter_captures(tree, file_content, 0, -1) do
        for _, n, _, _ in CLASS_IDENTIFIER_QUERY:iter_captures(node, file_content, 0, -1) do
            local start_row, start_column, _, _ = n:range()
            db:insert('classes', {
                file_path_id = file_path_id,
                namespace_id = namespace_id,
                name = vim.treesitter.get_node_text(n, file_content, nil),
                start_row = start_row,
                start_column = start_column,
            })
        end
    end
end

return M
