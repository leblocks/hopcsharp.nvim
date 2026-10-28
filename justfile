[windows]
set shell := ["pwsh", "-NoProfile", "-Command"]

default:
    @just --list

# get all dependencies that are needed for test execution
prepare:
    git clone --depth 1 https://github.com/nvim-lua/plenary.nvim .ci/vendor/pack/vendor/start/plenary.nvim
    git clone --depth 1 https://github.com/kkharji/sqlite.lua .ci/vendor/pack/vendor/start/sqlite.nvim
    git clone --depth 1 https://github.com/nvim-treesitter/nvim-treesitter .ci/vendor/pack/vendor/start/nvim-treesitter.nvim --branch master

test-file file:
    @echo 'running tests in {{file}}'
    nvim --headless --clean -u 'scripts/minimal_init.lua' -c "PlenaryBustedFile {{file}}"

test-folder folder:
    @echo 'running tests in {{folder}}'
    nvim --headless --clean -u scripts/minimal_init.lua -c "PlenaryBustedDirectory test/{{folder}} { minimal_init = 'scripts/minimal_init.lua', sequential = true }"

test:
    @echo 'running all tests'
    nvim --headless --clean -u scripts/minimal_init.lua -c "PlenaryBustedDirectory test/ { minimal_init = 'scripts/minimal_init.lua', sequential = true }"

format:
    stylua lua
    stylua test

lint: lint-stylua lint-luacheck

lint-stylua:
    stylua --color always --check lua
    stylua --color always --check test

lint-luacheck:
    luacheck lua/treetags
    luacheck test

