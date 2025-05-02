# hopcsharp.nvim


cached treesitter navigation on a big projects, an attempt to make navigation in large c# projects better

### description
todo

### requirements

- [squalite.lua](https://github.com/lrangell/sql.nvim)
- fd
* treesitter c_sharp language installed


### TODOs

#### refactorings

* move db to a separate folder as well
* store db files in cache folder? read vim.fn.stdpath docs
* restore is_processing on crash?
* check 3rd party integration in goto methods
* sources folder, make proper examples

#### first release

* goto_functionality
    * 1 match -> jump
    * provide ability to hook telescope\fzf-lua

* goto_definition
    * supported entities:
        * ~class~
            * attribute!
        * ~interface~
        * method
        * constructor
        * enum
        * record
        * struct

* goto_implementation
    * from class to subclass
    * from interface to implementation

* list_symbols
    * for fast navigation
    * list by
        * class
            * attribute!
        * interface
        * method
        * constructor
        * enum
        * record
        * struct

#### stretch

* goto_reference
* get_type_hierarchy
* visual buffer with init_db info (like in packer)




