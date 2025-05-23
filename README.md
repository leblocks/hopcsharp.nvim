# hopcsharp.nvim


cached treesitter navigation on a big projects, an attempt to make navigation in large c# projects better

### description
todo

### requirements

- [sqlite.lua](https://github.com/lrangell/sql.nvim)
- fd
* treesitter c_sharp language installed
* nvim-treesitter?


### api

#### init_database
documentation

#### hop_to_definition
documentation

#### hop_to_implementation
documentation

#### get_db
documentation


### customization examples

* Use database to get all definitions and navigate those with fzf-lua
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
                    local type = require('hopcsharp.database.utils').__get_type_name(entry.type)
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


### TODOs

#### roadmap

* make it faster (init_database)
    * profile! mooore

* update_database method (re-index changed files only)

* help

* checkhealth\requirement function

#### Nice to have in the future

* hop_to_implementation
    * from method def in an interface to implementation?
* hop_to_reference
* get_type_hierarchy
* hop_to_definition - context aware

