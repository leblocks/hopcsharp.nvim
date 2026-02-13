# hopcsharp.nvim

Cached treesitter navigation on a big projects, an attempt to make navigation in large c# projects better

## Description

_hopcsharp_ is a lightweight code navigation tool inspired by [ctags](https://github.com/universal-ctags/ctags), built
for large C# projects. It uses [tree-sitter](https://tree-sitter.github.io/tree-sitter/) to quickly (not blazing fast
but still good) parse code and store marks in a SQLite database for fast access, after that you can navigate freely in
code base using built in methods or writing queries on your own against sqlite database.

__This plugin is in its early stages__ expect lots of bugs :D, I hope that there will be people's interest and
contributions as well. I'll try to improve it little by little.

<p align="center">
   <img src="https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExN3Q0YTdkNWkxb2Z0d216eW5rcHB0N2dxd2htYXZiZGphbTZkNGRxdiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/HBGku9Wu9y0CtgXuCF/giphy.gif" />
</p>

## How does it work?

_hopcsharp_ parses code base with help of tree-sitter and stores data on type locations \ definitions
in local sqlite database. This database provides data for navigation in code. __It won't be as precise as LSP__
but it provides a fast way with pretty good precision for navigation in a codebase.

## Requirements

* [sqlite.lua](https://github.com/kkharji/sqlite.lua)
    * _windows_ may require you to download sqlite dll and additional configuration, take a look at [installation](https://github.com/kkharji/sqlite.lua?tab=readme-ov-file#-installation)
    instructions.

* [fd](https://github.com/sharkdp/fd) to be on _PATH_
* _c_sharp_ tree-sitter grammer installed

## Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use({ 'leblocks/hopcsharp.nvim', requires = { { 'kkharji/sqlite.lua' } } })
```

## Quick Start

Example keybinding configuration:

```lua
local hopcsharp = require('hopcsharp')

-- database
vim.keymap.set('n', '<leader>hD', hopcsharp.init_database, { desc = 'hopcsharp: init database' })

-- navigation
vim.keymap.set('n', '<leader>hd', hopcsharp.hop_to_definition, { desc = 'hopcsharp: go to definition' })
vim.keymap.set('n', '<leader>hi', hopcsharp.hop_to_implementation, { desc = 'hopcsharp: go to implementation' })
vim.keymap.set('n', '<leader>hr', hopcsharp.hop_to_reference, { desc = 'hopcsharp: go to reference' })
vim.keymap.set('n', '<leader>ht', hopcsharp.get_type_hierarchy, { desc = 'hopcsharp: type hierarchy' })

-- fzf pickers (requires fzf-lua)
local pickers = require('hopcsharp.pickers.fzf')
vim.keymap.set('n', '<leader>hf', pickers.source_files, { desc = 'hopcsharp: find source files' })
vim.keymap.set('n', '<leader>ha', pickers.all_definitions, { desc = 'hopcsharp: all definitions' })
vim.keymap.set('n', '<leader>hc', pickers.class_definitions, { desc = 'hopcsharp: class definitions' })
vim.keymap.set('n', '<leader>hn', pickers.interface_definitions, { desc = 'hopcsharp: interface definitions' })
vim.keymap.set('n', '<leader>he', pickers.enum_definitions, { desc = 'hopcsharp: enum definitions' })
```

## API
This plugin exposes only a small set of functions, allowing you to build various interfaces and workflows on top of them.

### init_database

```lua
require('hopcsharp').init_database()
```
This function launches the database initialization process in a separate headless Neovim instance to avoid blocking the
current session.

### hop_to_definition

```lua
require('hopcsharp').hop_to_definition(config)
```

Opens new buffer or switches to existing one on a line and column where definition is defined. If it finds more than
one definition it will add those to quickfix list and will open it. See `:h hopcsharp.hop_to_definition` for more details.

### hop_to_implementation

```lua
require('hopcsharp').hop_to_implementation(config)
```

Opens new buffer or switches to existing one on a line and column where implementation is defined. If it finds more than
one implementation it will add those to quickfix list and will open it. See `:h hopcsharp.hop_to_definition` for more details.

### hop_to_reference

```lua
require('hopcsharp').hop_to_reference(config)
```

Opens new buffer or switches to existing one on a line and column where reference is defined. If it finds more than
one reference it will add those to quickfix list and will open it. See `:h hopcsharp.hop_to_reference` for more details.

### get_type_hierarchy

```lua
require('hopcsharp').get_type_hierarchy()
```

Opens read-only buffer with type hierarchy.

### get_db

```lua
require('hopcsharp').get_db()
```

Returns opened _[sqlite_db](https://github.com/kkharji/sqlite.lua/blob/50092d60feb242602d7578398c6eb53b4a8ffe7b/doc/sqlite.txt#L76)_ object, you can create custom flows querying it with SQL queries from lua. See `:h hopcsharp.get_db` for more details.

## FZF Pickers

hopcsharp ships with built-in [fzf-lua](https://github.com/ibhagwan/fzf-lua) pickers for browsing definitions and source files. Requires the `fzf-lua` plugin to be installed.

All pickers are available via `require('hopcsharp.pickers.fzf')`:

| Picker | Description |
|---|---|
| `source_files` | Browse all `.cs` source files in the database |
| `all_definitions` | Browse all definitions |
| `class_definitions` | Browse class definitions |
| `interface_definitions` | Browse interface definitions |
| `method_definitions` | Browse method definitions |
| `struct_definitions` | Browse struct definitions |
| `enum_definitions` | Browse enum definitions |
| `record_definitions` | Browse record definitions |
| `attribute_definitions` | Browse attribute definitions |

See `:h hopcsharp-fzf-pickers` for more details.

