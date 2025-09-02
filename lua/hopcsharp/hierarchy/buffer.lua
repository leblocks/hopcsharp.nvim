local utils = require('hopcsharp.hop.utils')

local M = {}

-- TODO use existing hilghliht groups
-- TODO think of a better place?
local namespace = vim.api.nvim_create_namespace('hopcsharp')

local function tree_to_lines(node, lines, level)
    if node == nil then
        return
    end

    table.insert(lines, string.rep('   ', level, '') .. node.name)

    if node.children ~= nil then
        for _, child in ipairs(node.children) do
            tree_to_lines(child, lines, level + 1)
        end
    end
end

local function get_word_coordinates(word, lines)
    for row, line in ipairs(lines) do
        local col_start, col_end = string.find(line, word)
        if col_start then
            return { row = row - 1, col_start = col_start - 1, col_end = col_end }
        end
    end

    return nil
end

local function highlight(buf, group, word, lines)
    local coordinates = get_word_coordinates(word, lines)

    if coordinates == nil then
        return
    end

    vim.api.nvim_buf_set_extmark(buf, namespace, coordinates.row, coordinates.col_start, {
        end_row = coordinates.row,
        end_col = coordinates.col_end,
        hl_group = group
    })
end

M.__get_hierarchy_buffer_name = function(type_name)
    return 'hopcsharp://hierarchy/' .. type_name
end

M.__create_hierarchy_buffer = function(type_name, tree_root)
    local buffer_name = M.__get_hierarchy_buffer_name(type_name)
    local buffer_lines = {
        "Some pre-inserted text line1",
        "Some pre-inserted text line2",
        "",
    }

    local not_exists = function(path)
        local buf = vim.api.nvim_create_buf(true, true)

        -- populate hierarchy buffer content
        tree_to_lines(tree_root, buffer_lines, 0)

        -- TODO highlight type_name and set cursor at it
        -- local namespace_id = vim.api.nvim_create_namespace('')
        -- local row, col, line, width = get_coordinates(buffer_content, type_name)
        -- vim.api.nvim_buf_set_extmark(buf, namespace_id, line, column,

        vim.api.nvim_buf_set_name(buf, path)
        vim.api.nvim_buf_set_lines(buf, 0, -1, true, buffer_lines)

        highlight(buf, '@type', type_name, buffer_lines)

        local coords = get_word_coordinates(type_name, buffer_lines)

        vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
        vim.api.nvim_set_current_buf(buf)

        if coords ~= nil then
            print(vim.inspect(coords))
            vim.fn.setcursorcharpos(coords.row + 1, coords.col_start + 1)
        end
    end

    utils.__open_buffer(buffer_name, vim.api.nvim_set_current_buf, not_exists)
end

return M
