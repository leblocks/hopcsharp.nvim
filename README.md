# hopcsharp.nvim

Cached treesitter navigation on a big projects, an attempt to make navigation in large c# projects better

## Description

_hopcsharp_ is a lightweight code navigation tool inspired by [ctags](https://github.com/universal-ctags/ctags), built
for large C# projects. It uses [tree-sitter](https://tree-sitter.github.io/tree-sitter/) to quickly (not blazing fast
but still good) parse code and store marks in a SQLite database for fast access. For example to parse all files in
[dotnet framework reference source](https://github.com/microsoft/referencesource) it consists of 14641 _.cs_ files,
takes ~750 seconds, after that you can navigate freely in code base using built in methods or writing queries on your
own against sqlite database.

__This plugin is in its early stages__ expect lots of bugs :D, I hope that there will be people's interest and
contributions as well. I myself, don't have much of a free time, but I'll try to improve it little by little.

## Requirements

* [sqlite.lua](https://github.com/kkharji/sqlite.lua)
* [fd](https://github.com/sharkdp/fd)
* _c_sharp_ tree-sitter grammer installed

## Example installation

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

### Example customization

* Use _get_db()_ to get all definitions and navigate those with fzf-lua
refer to fzf-lua [documentation](https://github.com/ibhagwan/fzf-lua/wiki/Advanced#fzf-exec-cont-tbl) on custom pickers

```lua
    local list_types = function()
        -- get database (connection is always opened)
        local db = require('hopcsharp').get_db()
        -- query to get all definitions
        local query = require('hopcsharp.database.query').get_all_definitions
        require('fzf-lua').fzf_exec(function(fzf_cb)
            coroutine.wrap(function()
                local co = coroutine.running()
                for _, entry in pairs(db:eval(query)) do
                    -- get human readable type names e.g CLASS, INTERFACE and so on
                    local type = require('hopcsharp.database.utils').get_type_name(entry.type)
                    -- format whole line to be parsable afterwards in actions callbacks
                    fzf_cb(string.format("%-12s %-50s %-50s %s %s", type, entry.name, entry.path, entry.row, entry.column),
                        function() coroutine.resume(co) end)
                    coroutine.yield()
                end
                fzf_cb()
            end)()
        end, {
            actions = {
                -- on select hop to definition by path row and column
                ['default'] = function(selected)
                    local result = {}
                    for part in string.gmatch(selected[1], "([^ ]+)") do
                        table.insert(result, part)
                    end
                    require('hopcsharp.hop.utils').__hop(result[3], result[4] + 1, result[5])
                end
            }
        })
    end

    vim.keymap.set({ 'n' }, '<Leader>hl', list_types, { buffer = true })
```

## Roadmap \ Nice to have in the future
* vim helpfile documentation
* make hop_to_definition context aware - do not hop from definition of a method to another definitions with same name
* get_type_hierarchy - pretty self explanatory
* improve performance of init_database(), for example do not re-parse files that were not changed.
* checkhealth method

