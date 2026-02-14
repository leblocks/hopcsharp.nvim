local os = require('os')

local M = {}

local function check_fd()
    vim.health.start('fd')
    local exit_code = os.execute('fd --help')
    if exit_code == 0 then
        vim.health.ok('fd is on PATH')
    else
        vim.health.error('fd is not on PATH')
    end
end

local function check_sqlite_installation()
    vim.health.start('sqlite')
    local ok, _ = pcall(require, 'sqlite')
    if ok then
        vim.health.ok('sqlite plugin is installed')
    else
        vim.health.error('sqlite plugin is not found')
    end

    -- check windows specific config for sqlite
    if vim.loop.os_uname().sysname == 'Windows_NT' then
        local dll = io.open(vim.g.sqlite_clib_path, 'r')
        if dll ~= nil then
            vim.health.ok('sqlite_clib_path is set and points to a file: ' .. vim.g.sqlite_clib_path)
            io.close(dll)
        else
            vim.health.error('sqlite_clib_path is not set')
        end
    end
end

local function check_treesitter_c_sharp_grammar_installation()
    vim.health.start('treesitter')
    if vim.treesitter.language.add('c_sharp') then
        vim.health.ok('c_sharp grammar is installed')
    else
        vim.health.error('could not find c_sharp grammar')
    end
end

local function check_fzf_lua_optional()
    vim.health.start('fzf-lua [optional]')
    local ok, _ = pcall(require, 'fzf-lua')
    if ok then
        vim.health.ok('fzf-lua is installed')
    else
        vim.health.error('fzf-lua is not installed')
    end
end

M.check = function()
    check_fd()
    check_sqlite_installation()
    check_treesitter_c_sharp_grammar_installation()
    check_fzf_lua_optional()
end

return M
