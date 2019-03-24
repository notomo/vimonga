
function! vimonga#action#database#users#list(params) abort
    call vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#databases#model(a:params) })
        \.map_ok({ database -> vimonga#buffer#database#users#open(database, a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#user#list(buf.database) })
        \.map_ok({ buf, result -> vimonga#buffer#impl#content(buf.id, result['body']) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction
