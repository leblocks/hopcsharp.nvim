local dbutils = require('hopcsharp.database.utils')

local M = {}

-- TODO test + luadoc
M.__get_node_type = function(name, node)
    local node_type = nil
    if node then
        local parent_type = node:parent():type()

        if parent_type == 'attribute' then
            name = name .. 'Attribute'
            node_type = dbutils.types.CLASS
        end

        if parent_type == 'invocation_expression' then
            node_type = dbutils.types.METHOD
        end
    end

    return name, node_type
end


return M
