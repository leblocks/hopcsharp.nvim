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

#### refactorings

* store db files in cache folder? read vim.fn.stdpath docs
* restore is_processing on crash?
* check 3rd party integration in hop methods
* checkhealth\requirement function
* DRY all __parse_XXX methods

#### first release

* hop_to_definition
    * supported entities:
        * ~class~
            * ~attribute!~
        * ~interface~
        * record
        * struct
        * ~enum~
        * method
        * constructor

* hop_to_implementation
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

* hop_to_reference
* get_type_hierarchy
* visual buffer with init_db info (like in packer)




