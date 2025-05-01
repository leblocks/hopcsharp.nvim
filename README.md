# hopcsharp.nvim


cached treesitter navigation on a big projects, an attempt to make navigation in large c# projects better

### description
todo

### requirements

- [squalite.lua](https://github.com/lrangell/sql.nvim)
- fd


### TODOs

#### refactorings

* store db files in cache folder? read vim.fn.stdpath docs
* DRY insert unique methods, like __insert_file and __insert_namespace
* pull out queries into separate file
* restore is_processing on crash?
* split parsing in files (separate file for class parser, separate one for interface and so on...)
* check 3rd party integration in goto methods

#### first release

* goto_functionality
    * 1 match -> jump
    * provide ability to hook telescope\fzf-lua

* goto_definition
    * supported entities:
        * ~class~
        * ~interface~
        * method
        * constructor
        * enum

* goto_implementation
    * from class to subclass
    * from interface to implementation

* list_symbols
    * for fast navigation
    * list by
        * class
        * interface
        * method
        * constructor
        * enum

#### stretch

* goto_reference
* get_type_hierarchy
* visual buffer with init_db info (like in packer)




