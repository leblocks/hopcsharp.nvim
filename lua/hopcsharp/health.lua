local M = {}

local function check_fd()
end

local function check_sqlite_installation()
end

local function check_treesitter_c_sharp_grammar_installation()
    vim.health.start('treesitter')
    if vim.treesitter.language.add('c_sharp') then
        vim.health.ok('c_sharp grammar is installed')
    else
        vim.health.error('could not find c_sharp grammar')
    end
end

M.check = function()
    check_fd()
    check_sqlite_installation()
    check_treesitter_c_sharp_grammar_installation()
end

return M
