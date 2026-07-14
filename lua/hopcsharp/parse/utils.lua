local debug = require('hopcsharp.debug')

local M = {}

---@param query string
---@return vim.treesitter.Query
M.__get_query = function(query)
    local ok, result = pcall(vim.treesitter.query.parse, 'c_sharp', query)

    if ok then
        return result
    end

    debug.__log_error('treesitter c_sharp parser is not found')

    return nil
end

---@param query vim.treesitter.Query
---@param tree TSNode
---@param file_content string
---@param callback function
M.__icaptures = function(query, tree, file_content, callback)
    for _, node, _, _ in query:iter_captures(tree, file_content, 0, -1) do
        callback(node, file_content)
    end
end

M.__get_commit_hash = function()
    local output = vim.system({ 'git', 'rev-parse', 'HEAD' }, { text = true, cwd = vim.fn.getcwd() }):wait()

    if output.code == 0 then
        -- remove newlines from stdout
        return output.stdout:gsub('\r?\n$', '')
    end

    return nil
end

M.__get_changed_files = function(start_commit, end_commit, diff_filter)

    local arguments = {
        'git',
        'diff',
        '--name-only',
        start_commit,
        end_commit,
    }

    if diff_filter then
        table.insert(arguments, '--diff-filter=' .. diff_filter)
    end

    debug.__log_debug('__get_changed_files ' .. vim.inspect(arguments))

    local result = vim.system(arguments, { text = true, cwd = vim.fn.getcwd() }):wait()

    debug.__log_debug(vim.inspect(result))

    local files = {}

    for line in result.stdout:gmatch('([^\n]*)\n?') do
        if (line ~= '') and (line:match('cs$')) then
            table.insert(files, line)
        end
    end

    return files
end

return M
