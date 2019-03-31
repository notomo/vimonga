
function! vimonga#action#databases#list(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#connections#model(a:params) })
        \.map_ok({ conn -> vimonga#buffer#databases#open(conn, a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#database#list(buf.connection) })
        \.map_ok({ buf, names -> vimonga#buffer#impl#content(buf.id, names) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction

function! vimonga#action#databases#drop(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#databases#model(a:params) })
        \.map_through_ok({ database -> vimonga#message#confirm_strongly('Drop ' . database.name . '?') })
        \.map_through_ok({ database -> vimonga#repo#database#drop(database) })
        \.map_ok({ database -> vimonga#buffer#databases#open(database.connection(), a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#database#list(buf.connection) })
        \.map_ok({ buf, names -> vimonga#buffer#impl#content(buf.id, names) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction
