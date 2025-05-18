local database = require('hopcsharp.database')
local utils = require('hopcsharp.database.utils')

describe('database.utils', function()
    it('__get_db_file_name works for windows path', function()
        local name = utils.__get_db_file_name('C:\\Users\\john\\repos\\dotfiles')
        assert(name == 'C--Users-john-repos-dotfiles.sql')
    end)

    it('__get_db_file_name works for linux path', function()
        local name = utils.__get_db_file_name('/home/john/nvim')
        assert(name == 'home-john-nvim.sql')
    end)
end)
