
function! vimonga#action#databases#list(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#connections#model(a:params) })
        \.map_ok({ conn -> vimonga#buffer#databases#open(conn, a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#database#list(buf.connection) })
        \.map_ok({ buf, names -> vimonga#buffer#impl#content(buf, names) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction

function! vimonga#action#databases#drop(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#databases#models(a:params) })
        \.map_through_ok({ databases -> vimonga#message#confirm_strongly('Drop ' . join(map(copy(databases), {_, db -> db.name}), ' ') . '?', a:params.force) })
        \.map_through_ok({ databases -> vimonga#repo#database#drop(databases) })
        \.map_ok({ databases -> vimonga#buffer#databases#open(databases[0].connection(), a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#database#list(buf.connection) })
        \.map_ok({ buf, names -> vimonga#buffer#impl#content(buf, names) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction
