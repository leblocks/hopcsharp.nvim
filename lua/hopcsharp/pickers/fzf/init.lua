local ok, _ = pcall(require, 'fzf-lua')
if not ok then
    error("hopcsharp.pickers.fzf was required but 'fzf-lua' plugin was not found")
end

local fzf = require('fzf-lua')
local builtin = require('fzf-lua.previewer.builtin')
local hopcsharp = require('hopcsharp')
local file = require('hopcsharp.pickers.fzf.file')
local utils = require('hopcsharp.pickers.fzf.utils')
local db_query = require('hopcsharp.database.query')
local db_utils = require('hopcsharp.database.utils')

local M = {}

local get_items_by_type = function(type)
    local db = hopcsharp.get_db()
    return function()
        return db:eval(db_query.get_definition_by_type, { type = type })
    end
end

local get_items_by_type_picker = function(item_type)
    return utils.__get_picker(fzf, builtin, get_items_by_type(item_type), utils.__format_name_and_namespace)
end

-- TODO add documentation in vimdoc
M.source_files = file.__source_files(fzf)

-- TODO add documentation in vimdoc
M.all_definitions = utils.__get_picker(fzf, builtin, function()
    local db = hopcsharp.get_db()
    return db:eval(db_query.get_all_definitions)
end, utils.__format_name_and_namespace)

-- TODO add documentation in vimdoc
M.class_definitions = get_items_by_type_picker(db_utils.types.CLASS)

-- TODO add documentation in vimdoc
M.interface_definitions = get_items_by_type_picker(db_utils.types.INTERFACE)

-- TODO add documentation in vimdoc
M.method_definitions = get_items_by_type_picker(db_utils.types.METHOD)

-- TODO add documentation in vimdoc
M.struct_definitions = get_items_by_type_picker(db_utils.types.STRUCT)

-- TODO add documentation in vimdoc
M.enum_definitions = get_items_by_type_picker(db_utils.types.ENUM)

-- TODO add documentation in vimdoc
M.record_definitions = get_items_by_type_picker(db_utils.types.RECORD)

-- TODO add documentation in vimdoc
M.attribute_definitions = utils.__get_picker(fzf, builtin, function()
    local db = hopcsharp.get_db()
    return db:eval(db_query.get_attributes)
end, utils.__format_name_and_namespace)

return M
