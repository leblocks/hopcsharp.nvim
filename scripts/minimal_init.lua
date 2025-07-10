vim.opt.runtimepath:append(".")

local cwd = vim.fn.getcwd()
vim.cmd(string.format([[set packpath=%s/.ci/vendor]], cwd))
vim.cmd([[packloadall]])

vim.o.swapfile = false
vim.bo.swapfile = false
vim.g.sqlite_clib_path = os.getenv('NEOVIM_SQLITE_DLL_PATH')

require("nvim-treesitter.configs").setup {
    indent = { enable = true },
    highlight = { enable = true },
    ensure_installed = { "c_sharp", },
    sync_install = true
}

