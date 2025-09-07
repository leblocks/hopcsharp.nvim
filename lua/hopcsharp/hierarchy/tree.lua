local M = {}

---@class HierarchyTreeNode
---@field name string Name of the node
---@field children HierarchyTreeNode[] Children of the current node

---@param root HierarchyTreeNode Root node of the hierarchy tree
---@param prefix string Prefix that will be used to indent tree nodes
---@return string[] Table with string representation of a tree
M.__tree_to_lines = function(root, prefix)
    local lines = {}

    ---@param node HierarchyTreeNode Node of the hierarchy tree
    ---@param level number Depth level of a node
    local function build(node, level)
        if node == nil then
            return
        end

        if node.name == nil then
            return
        end

        table.insert(lines, string.rep(prefix, level, '') .. node.name)

        if node.children ~= nil then
            for _, child in ipairs(node.children) do
                build(child, level + 1)
            end
        end
    end

    build(root, 0)

    return lines
end

---@param root HierarchyTreeNode Root node of the hierarchy tree
---@return string[] Table with string representation of a tree
M.__get_leaf_nodes = function(root)
    -- TODO
    return {}
end

return M
