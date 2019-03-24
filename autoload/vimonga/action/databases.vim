
function! vimonga#action#databases#list(params) abort
    let conn = vimonga#buffer#connections#model(a:params)
    call vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#databases#open(conn, a:params.open_cmd) })
        \.map_extend_ok({ _ -> vimonga#repo#database#list() })
        \.map_ok({ buf, result -> vimonga#buffer#impl#content(buf, result['body']) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction

function! vimonga#action#databases#drop(params) abort
    call vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#databases#model(a:params) })
        \.map_through_ok({ database -> vimonga#message#confirm_strongly('Drop ' . database.name . '?') })
        \.map_through_ok({ database -> vimonga#repo#database#drop(database) })
        \.map_ok({ database -> vimonga#buffer#databases#open(database.connection(), a:params.open_cmd) })
        \.map_extend_ok({ _ -> vimonga#repo#database#list() })
        \.map_ok({ buf, result -> vimonga#buffer#impl#content(buf, result['body']) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction
