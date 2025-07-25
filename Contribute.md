# Contributing to hopcsharp.nvim

First off, thanks for your interest in contributing!   
This plugin is still early in development, so all help is appreciated — from bug reports and feature ideas to pull requests.

---

##  Local Development Setup

To start contributing to `hopcsharp.nvim`, follow the steps below to get your local development environment ready.

### Requirements

- [Neovim (0.9+)](https://neovim.io/)
- [Tree-sitter CLI](https://tree-sitter.github.io/tree-sitter/)
- [fd](https://github.com/sharkdp/fd) (must be available on your system's PATH)
- [sqlite3](https://www.sqlite.org/)
- [stylua](https://github.com/JohnnyMorganz/StyLua) for formatting
- [luacheck](https://github.com/mpeterv/luacheck) for linting
- Optionally: `dotnet` SDK (for testing against real C# projects)
- You must have the C# Tree-sitter grammar installed

### Clone the Repo

```bash
git clone https://github.com/leblocks/hopcsharp.nvim.git
cd hopcsharp.nvim
```
---
## Getting Started
You can prepare your environment and run tests via the Makefile.

### Install Dependencies (Plenary, Sqlite, Treesitter)
```bash
make prepare
```
This will clone required test plugins into `.ci/vendor`.
### Run Tests
```bash
make test
```
This uses `PlenaryBusted` with a minimal init located in `scripts/minimal_init.lua`.

### Lint Code
```bash
make lint
```
Runs `luacheck` on both `lua/` and `test/`.

---

## Code Style
* Format code with [StyLua](https://github.com/JohnnyMorganz/StyLua)

```bash
stylua lua/ test/
```
* Lint using [Luacheck](https://github.com/mpeterv/luacheck)

```bash
luacheck lua/ test/
```
* Config is defined in:
   - `.stylua.toml`
   - `.luacheckrc`

---

## Writing Tests
Tests are written using plenary.nvim's Busted runner.
Test files are located in the test/ directory.

To run all tests headlessly:

```bash
make test
```
Example:
See `test/parse/definition_spec.lua` for an example of testing database population via treesitter parsing.

---

## Contributing Guidelines
1. Fork the repository
2. Create a new branch for your feature or fix:

```bash
git checkout -b feature/my-cool-change
```
3. Commit with clear messages
4. Ensure tests pass and code is linted
5. Submit a Pull Request

--- 
## Plugin Internals
* Main logic lives in `lua/hopcsharp/`
* Treesitter parsing and SQL storage via `sqlite.lua`
* Treesitter grammar must include `c_sharp`
* You can query the SQLite DB using the public API:
```lua
require('hopcsharp').get_db():eval("SELECT * FROM definitions")
```

---

# **Thanks**
Thanks again for your contribution. This plugin is being built slowly, but with love.
Your input helps shape it into something better for everyone.

#### If you get stuck, feel free to open an issue or ask in a discussion!
---