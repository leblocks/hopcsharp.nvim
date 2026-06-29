local database = require('hopcsharp.database')
local using = require('hopcsharp.parse.using')
local utils = require('hopcsharp.parse.utils')
local history = require('hopcsharp.parse.history')
local namespace = require('hopcsharp.parse.namespace')
local reference = require('hopcsharp.parse.reference')
local definition = require('hopcsharp.parse.definition')
local inheritance = require('hopcsharp.parse.inheritance')
local type_argument = require('hopcsharp.parse.type_argument')

local M = {}

M.__get_outdated_source_files = function()
    local last_commit = history.__get_last_parsed_commit()

    -- no history, get all files
    if last_commit == '' then
        return M.__get_source_files()
    end

    -- get only changed ones
    return utils.__get_changed_files(last_commit, '.')
end

M.__get_source_files = function()
    local result = vim.system({ 'fd', '--extension', 'cs' }, { text = true, cwd = vim.fn.getcwd() }):wait()

    local files = {}

    for line in result.stdout:gmatch('([^\n]*)\n?') do
        if line ~= '' then
            table.insert(files, line)
        end
    end

    return files
end

M.__parse_tree = function(file_path, callback, writer)
    local db = database.__get_db()
    local file, err = io.open(file_path, 'r')

    if not file then
        print('error opening ' .. file_path .. ' error: ' .. err)
        return
    end

    local _, id = db:insert('files', { path = file_path })

    local file_content = file:read('*a')
    local parser = vim.treesitter.get_string_parser(file_content, 'c_sharp', { error = false })

    if not parser then
        return
    end

    parser:parse(false, function(_, trees)
        if not trees then
            return
        end

        parser:for_each_tree(function(tree, _)
            callback(tree, id, file_content, writer)
        end)
    end)

    file:close()
end

M.__parse_file = function(file_path, writer)
    M.__parse_tree(file_path, function(tree, path_id, file_content, wr)
        local root = tree:root()
        local namespace_id = namespace.__parse_namespaces(root, path_id, file_content)
        using.__parse_usings(root, path_id, file_content, wr)
        definition.__parse_definitions(root, path_id, namespace_id, file_content, wr)
        inheritance.__parse_inheritance(root, path_id, namespace_id, file_content, wr)
        reference.__parse_reference(root, path_id, namespace_id, file_content, wr)
        type_argument.__parse_type_arguments(root, path_id, namespace_id, file_content, wr)
    end, writer)
end

return M
