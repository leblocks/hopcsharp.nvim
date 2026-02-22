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

    it('__get_definitions_insert_command empty succeeds', function()
        local command = utils.__get_definitions_insert_command({})
        assert(command == '')
    end)

    it('__get_definitions_insert_command nil succeeds', function()
        local command = utils.__get_definitions_insert_command(nil)
        assert(command == '')
    end)

    it('__get_definitions_insert_command succeeds', function()
        local entries = {
            { path_id = 1, namespace_id = 2, type = 3, name = 'Test1', row = 4, column = 5 },
            { path_id = 1, namespace_id = 2, type = 3, name = 'Test2', row = 4, column = 5 },
        }
        local expected_command = [[INSERT INTO definitions (path_id, namespace_id, type, name, row, column) VALUES (1, 2, 3, "Test1", 4, 5),(1, 2, 3, "Test2", 4, 5);]]
        local command = utils.__get_definitions_insert_command(entries)
        assert(command == expected_command)
    end)

    it('__get_definitions_insert_command single element succeeds', function()
        local entries = { { path_id = 1, namespace_id = 2, type = 3, name = 'Test1', row = 4, column = 5 }, }
        local expected_command = [[INSERT INTO definitions (path_id, namespace_id, type, name, row, column) VALUES (1, 2, 3, "Test1", 4, 5);]]
        local command = utils.__get_definitions_insert_command(entries)
        assert(command == expected_command)
    end)

    it('__get_references_insert_command succeeds', function()
        local entries = {
            { path_id = 1, namespace_id = 2, type = 3, name = 'Test1', row = 4, column = 5 },
            { path_id = 1, namespace_id = 2, type = 3, name = 'Test2', row = 4, column = 5 },
        }
        local expected_command = [[INSERT INTO reference (path_id, namespace_id, type, name, row, column) VALUES (1, 2, 3, "Test1", 4, 5),(1, 2, 3, "Test2", 4, 5);]]
        local command = utils.__get_references_insert_command(entries)
        assert(command == expected_command)
    end)

    it('__get_references_insert_command single element succeeds', function()
        local entries = { { path_id = 1, namespace_id = 2, type = 3, name = 'Test1', row = 4, column = 5 }, }
        local expected_command = [[INSERT INTO reference (path_id, namespace_id, type, name, row, column) VALUES (1, 2, 3, "Test1", 4, 5);]]
        local command = utils.__get_references_insert_command(entries)
        assert(command == expected_command)
    end)
end)
