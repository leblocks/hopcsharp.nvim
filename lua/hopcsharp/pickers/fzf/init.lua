-- TODO how can it be tested?
-- TODO make this module conditional
local fzf = require('fzf-lua')
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

-- TODO add documentation in vimdoc
M.source_files = file.__source_files(fzf)

-- TODO add documentation in vimdoc
M.all_definitions = utils.__get_picker(fzf, function()
    local db = hopcsharp.get_db()
    return db:eval(db_query.get_all_definitions)
end, utils.__format_name_and_namespace)

-- TODO add documentation in vimdoc
M.class_definitions =
    utils.__get_picker(fzf, get_items_by_type(db_utils.types.CLASS), utils.__format_name_and_namespace)

-- TODO add documentation in vimdoc
M.interface_definitions =
    utils.__get_picker(fzf, get_items_by_type(db_utils.types.INTERFACE), utils.__format_name_and_namespace)

-- TODO add documentation in vimdoc
M.method_definitions =
    utils.__get_picker(fzf, get_items_by_type(db_utils.types.METHOD), utils.__format_name_and_namespace)

-- TODO add documentation in vimdoc
M.struct_definitions =
    utils.__get_picker(fzf, get_items_by_type(db_utils.types.STRUCT), utils.__format_name_and_namespace)

-- TODO add documentation in vimdoc
M.enum_definitions = utils.__get_picker(fzf, get_items_by_type(db_utils.types.ENUM), utils.__format_name_and_namespace)

-- TODO add documentation in vimdoc
M.struct_definitions =
    utils.__get_picker(fzf, get_items_by_type(db_utils.types.STRUCT), utils.__format_name_and_namespace)

-- TODO add documentation in vimdoc
M.record_definitions =
    utils.__get_picker(fzf, get_items_by_type(db_utils.types.RECORD), utils.__format_name_and_namespace)

-- TODO add documentation in vimdoc
M.attribute_definitions = utils.__get_picker(fzf, function()
    local db = hopcsharp.get_db()
    return db:eval(db_query.get_attributes)
end, utils.__format_name_and_namespace)

return M
