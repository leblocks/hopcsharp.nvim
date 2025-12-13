# Contributing to hopcsharp.nvim

Thank you for your interest in contributing to hopcsharp.nvim! This document provides guidelines and instructions
for contributing to the project.

## Development Setup

### Prerequisites

- Same as in the plugin itself (check [README](./README.md))

### Dependencies for Testing

- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) - Test framework

## Running Tests

### Using Make

If you have `make` installed, you can use the provided Makefile:

1. **Prepare the test environment** (downloads dependencies):
   ```bash
   make prepare
   ```

2. **Run tests**:
   ```bash
   make test
   ```

3. **Run linter**:
   ```bash
   make lint
   ```

### Without Make

If you don't have `make` installed, you can run the commands manually:

1. **Prepare the test environment**:
   ```bash
   # Clone test dependencies
   git clone --depth 1 https://github.com/nvim-lua/plenary.nvim .ci/vendor/pack/vendor/start/plenary.nvim
   git clone --depth 1 https://github.com/kkharji/sqlite.lua .ci/vendor/pack/vendor/start/sqlite.nvim
   git clone --depth 1 https://github.com/nvim-treesitter/nvim-treesitter .ci/vendor/pack/vendor/start/nvim-treesitter.nvim
   ```

2. **Run tests**:
   ```bash
   nvim --headless --clean -u scripts/minimal_init.lua -c "PlenaryBustedDirectory test/ { minimal_init = 'scripts/minimal_init.lua', sequential = true }"
   ```

3. **Run linter** (requires luacheck):
   ```bash
   luacheck lua/hopcsharp
   luacheck test
   ```

## Code Style

This project uses:

- **Stylua** for Lua code formatting (configuration in `.stylua.toml`)
- **Luacheck** for linting (configuration in `.luacheckrc`)
- **EditorConfig** for consistent editor settings (`.editorconfig`)

Please ensure your code follows these standards:

1. Format your code with Stylua before committing:
   ```bash
   stylua lua/ test/
   ```

2. Check for linting issues:
   ```bash
   luacheck lua/hopcsharp test
   ```

3. Follow the existing code patterns and conventions in the codebase

## Project Structure

```
hopcsharp.nvim/
├── lua/hopcsharp/         # Main plugin code
│   ├── init.lua           # Entry point
│   │
│   ├── database/          # Database-related functionality
│   │                      # schema definition, queries etc.
│   │
│   ├── hierarchy/         # Most of get_type_hiearchy implementation
│   │
│   ├── hop/               # Navigation features: hop_to_XXX methods
│   │
│   └── parse/             # Parsing utilities (used during code database buildup)
│                          # treesitter queries and methods to extract data about code base
│
├── test/                  # Test files
│   │
│   ├── sources/           # C# source files for testing, be careful when updating those
│   │                      # it may ruin existing asserts in tests
│   │
│   └── *_spec.lua         # Tests
│
├── scripts/               # Scripts for ci and testing
│
└── doc/                   # Vimdoc
```

## Submitting Changes

Always write tests for your changes.

### Commit Message Guidelines

We are mostly trying to follow [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) format :)

## Reporting Issues

When reporting issues, please include:

1. **Neovim version**: Output of `nvim --version`
2. **Operating System**: Windows/Linux/macOS and version
3. **Minimal configuration** to reproduce the issue
4. **Steps to reproduce** the problem
5. **Expected behavior** vs **Actual behavior**
6. **Error messages** or logs if applicable

## Development Tips

1. **Testing with large C# projects**: The plugin is designed for large codebases. Test your changes with substantial
C# projects like the [.NET Reference Source](https://github.com/microsoft/referencesource)

2. **Database debugging**: You can inspect the SQLite database directly in lua code:
   ```lua
   local db = require('hopcsharp').get_db()
   local results = db:eval("SELECT * FROM files LIMIT 10")
   vim.inspect(results)
   ```
   or just connect to sqlite file in _nvim-data_ folder with any db client.

3. **Performance considerations**: Since this plugin is designed for large projects, always consider performance implications of your changes

## Questions?

If you have questions about contributing, feel free to:

- Create an issue.
- Check existing issues and pull requests for similar topics

Thank you for contributing to hopcsharp.nvim! 🚀
