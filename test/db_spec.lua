local db = require('hopcsharp.db')

describe('db', function()
    it('__get_db_file_name works for windows path', function()
        local name = db.__get_db_file_name('C:\\Users\\john\\repos\\dotfiles')
        assert(name == 'C--Users-john-repos-dotfiles.sql')
    end)

    it('__get_db_file_name works for linux path', function()
        local name = db.__get_db_file_name('/home/john/nvim')
        assert(name == 'home-john-nvim.sql')
    end)

    it('__get_path_to_db_file provides correct path', function()
        local path = db.__get_path_to_db_folder()
        assert(path:match("data/hopcsharp$"))
    end)

end)
