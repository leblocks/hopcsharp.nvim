# hopcsharp.nvim
cached treesitter navigation on a big projects, an attempt to make navigation in large c# projects better

### requirements
- [plenary](https://github.com/nvim-lua/plenary.nvim)
- [squalite.lua](https://github.com/lrangell/sql.nvim)

### MVP TODOs

* being able to parse really huge c_sharp repository

* class
    * goto_definition
    * goto_reference


* build db with following tables

* namespaces
    * id
    * name

* class_declaration
    * id
    * name
    * file_name
    * location
    * is_public
    * is_private
    * is_internal
    * is_abstract
    * is_partial
    * is_static

* class_reference - TODO
    * id



### NON MVP
* see how to write and generate docs here https://www.youtube.com/watch?v=n4Lp4cV8YR0



