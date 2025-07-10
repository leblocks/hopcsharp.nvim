.PHONY: test prepare

prepare:
	git clone --depth 1 https://github.com/nvim-lua/plenary.nvim .ci/vendor/pack/vendor/start/plenary.nvim
	git clone --depth 1 https://github.com/kkharji/sqlite.lua .ci/vendor/pack/vendor/start/sqlite.nvim
	git clone --depth 1 https://github.com/nvim-treesitter/nvim-treesitter .ci/vendor/pack/vendor/start/nvim-treesitter.nvim

test:
	nvim --headless --clean -u scripts/minimal_init.lua -c "PlenaryBustedDirectory test/ { minimal_init = 'scripts/minimal_init.lua', sequential = true }"


