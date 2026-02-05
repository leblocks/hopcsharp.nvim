local hopcsharp = require('hopcsharp')

local M = {}

M.__source_files = function(fzf)
    return function()
        fzf.fzf_exec(function(fzf_cb)
            coroutine.wrap(function()
                local db = hopcsharp.get_db()
                local co = coroutine.running()
                local items = db:eval([[ SELECT path FROM files ]])

                if type(items) ~= 'table' then
                    items = {}
                end

                for _, entry in pairs(items) do
                    fzf_cb(entry.path, function()
                        coroutine.resume(co)
                    end)
                    coroutine.yield()
                end
                fzf_cb()
            end)()
        end, {
            actions = {
                ['enter'] = fzf.actions.file_edit_or_qf,
                ['ctrl-s'] = fzf.actions.file_split,
                ['ctrl-v'] = fzf.actions.file_vsplit,
                ['ctrl-t'] = fzf.actions.file_tabedit,
                ['alt-q'] = fzf.actions.file_sel_to_qf,
                ['alt-Q'] = fzf.actions.file_sel_to_ll,
                ['alt-i'] = fzf.actions.toggle_ignore,
                ['alt-h'] = fzf.actions.toggle_hidden,
                ['alt-f'] = fzf.actions.toggle_follow,
            },
            previewer = 'builtin',
        })
    end
end

return M
