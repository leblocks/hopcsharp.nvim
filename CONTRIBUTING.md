# Contributing to hopcsharp.nvim

Thank you for your interest in contributing to hopcsharp.nvim! This document provides guidelines and instructions
for contributing to the project.

## Development Setup

### Prerequisites

- Same as in the plugin itself (check [README](./README.md))

### Dependencies for Testing

- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) - Test framework

## Running Tests

### Using just

Install [just](https://github.com/casey/just), then use the recipes in the `justfile`:

1. **Prepare the test environment** (downloads dependencies):
   ```bash
   just prepare
   ```

2. **Run tests**:
   ```bash
   just test
   ```

3. **Run linter**:
   ```bash
   just lint
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
C# projects like the [.NET Reference Source](https://github.com/microsoft/referencesource) or [azure-sdk-for-net](https://github.com/Azure/azure-sdk-for-net)
latter is especially heave, around 100k source code files.

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
