local M = {}

M.__get_db_file_name = function(work_dir)
    return vim.fs.normalize(work_dir)
        :gsub('[:/]', '-')
        :gsub('^-', '') .. '.sql'
end

return M
