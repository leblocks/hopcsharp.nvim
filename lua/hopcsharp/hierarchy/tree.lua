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
    local nodes = {}

    ---@param node HierarchyTreeNode Node of the hierarchy tree
    local function walk(node)
        if node == nil then
            return
        end

        if node.name == nil then
            return
        end

        if node.children == nil or #node.children == 0 then
            table.insert(nodes, node.name)
        else
            for _, child in ipairs(node.children) do
                walk(child)
            end
        end
    end

    walk(root)

    return nodes
end

---@param name string Name of the node
---@param children HierarchyTreeNode[] Children of the current node
---@return HierarchyTreeNode A node with name and children
M.__create_node = function(name, children)
    return { name = name, children = children or {} }
end

return M
