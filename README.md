# hopcsharp.nvim


cached treesitter navigation on a big projects, an attempt to make navigation in large c# projects better

### description
todo

### requirements

- [squalite.lua](https://github.com/lrangell/sql.nvim)
- fd
* treesitter c_sharp language installed
* nvim-treesitter?


### TODOs

#### general

* store db files in cache folder? read vim.fn.stdpath docs
* restore is_processing on crash? (make it global?)
* check 3rd party integration in hop methods
* checkhealth\requirement function
* hop tests!!!
* hop format table
    * sort by namespace\filename?
    * jumping in an unexpected coord (from attr to method for example) is it ok?
    * remove current position from the list


#### roadmap

* hop_to_definition (done)

* hop_to_implementation
    * from class to subclass
    * from interface to implementation
    * from method def in a interface to implementation?

* list_all + hop (fzf-lua example)
    * for fast navigation with picker (fzf-lua or telescope

* make it faster (init_database)
    * profile!


#### stretch

* hop_to_reference
* get_type_hierarchy
* visual buffer with init_db info (like in packer)

