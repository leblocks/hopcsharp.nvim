# hopcsharp.nvim

Cached treesitter navigation on a big projects, an attempt to make navigation in large c# projects better

## Description

_hopcsharp_ is a lightweight code navigation tool inspired by [ctags](https://github.com/universal-ctags/ctags), built
for large C# projects. It uses [tree-sitter](https://tree-sitter.github.io/tree-sitter/) to quickly (not blazing fast
but still good) parse code and store marks in a SQLite database for fast access, after that you can navigate freely in
code base using built in methods or writing queries on your own against sqlite database.

__This plugin is in its early stages__ expect lots of bugs :D, I hope that there will be people's interest and
contributions as well. I myself, don't have much of a free time, it took me 3 months to get to the current (22072025)
state of things, but I'll try to improve it little by little.

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
require('hopcsharp').hop_to_definition(callback)
```

Opens new buffer or switches to existing one on a line and column where definition is defined. If it finds more than
one definition it will add those to quickfix list and will open it. If _callback_ is provided, instead of opening
defintions in a quickfix list, _callback_ will be invoked.

### hop_to_implementation

```lua
require('hopcsharp').hop_to_implementation(callback)
```

Opens new buffer or switches to existing one on a line and column where implementation is defined. If it finds more than
one implementation it will add those to quickfix list and will open it. If _callback_ is provided, instead of opening
implementations in a quickfix list, _callback_ will be invoked.

### get_db

```lua
require('hopcsharp').get_db()
```

Returns opened _[sqlite_db](https://github.com/kkharji/sqlite.lua/blob/50092d60feb242602d7578398c6eb53b4a8ffe7b/doc/sqlite.txt#L76)_ object, you can create custom flows querying it with SQL queries from lua. See customization

## Example customizations

[Here](https://github.com/leblocks/dotfiles/blob/master/packages/neovim/config/lua/plugins/hopcsharp.lua) (this is my
configuration that I use day to day) you can take a look at example configuration based on _get_db()_ method and _[fzf-lua](https://github.com/ibhagwan/fzf-lua)_,
here is demo usage of it on a [net framework reference source](https://github.com/microsoft/referencesource) repository

![demo](https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExODhzM2JnMTc1eGZ0ajB5cjFvNXF5ZDV1aDFkbG5saWhwcGo4a3o2ZSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/HXFp3DblkKtrcOBn8J/giphy.gif)

Create repository _.cs_ files fzf-lua picker that were previously stored in a db:

![demo](https://media.giphy.com/media/jvaFNuMIKjvHsACiBM/giphy.gif)

```lua
local list_files = function()
    -- get database (connection is always opened)
    fzf_lua.fzf_exec(function(fzf_cb)
        coroutine.wrap(function()
            local db = hopcsharp.get_db()
            local co = coroutine.running()
            local items = db:eval([[ SELECT path FROM files ]])

            if type(items) ~= 'table' then
                items = {}
            end

            for _, entry in pairs(items) do
                fzf_cb(entry.path, function() coroutine.resume(co) end)
                coroutine.yield()
            end
            fzf_cb()
        end)()
    end, {
        actions = {
            ["enter"]  = actions.file_edit_or_qf,
            ["ctrl-s"] = actions.file_split,
            ["ctrl-v"] = actions.file_vsplit,
            ["ctrl-t"] = actions.file_tabedit,
            ["alt-q"]  = actions.file_sel_to_qf,
            ["alt-Q"]  = actions.file_sel_to_ll,
            ["alt-i"]  = actions.toggle_ignore,
            ["alt-h"]  = actions.toggle_hidden,
            ["alt-f"]  = actions.toggle_follow,
        }
    })
end
```

