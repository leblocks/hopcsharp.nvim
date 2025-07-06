local utils = require('hopcsharp.database.utils')

describe('database.utils', function()
    it('__get_db_file_name works for windows path', function()
        -- TODO fails on linux for some reason
        local name = P(utils.__get_db_file_name('C:\\Users\\john\\repos\\dotfiles'))
        assert(name == 'C--Users-john-repos-dotfiles.sql')
    end)

    it('__get_db_file_name works for linux path', function()
        local name = utils.__get_db_file_name('/home/john/nvim')
        assert(name == 'home-john-nvim.sql')
    end)
end)
