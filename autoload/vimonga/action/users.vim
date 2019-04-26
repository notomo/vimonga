
function! vimonga#action#users#list(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#databases#model(a:params) })
        \.map_ok({ database -> vimonga#buffer#users#open(database, a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#user#list(buf.database) })
        \.map_ok({ buf, lines -> vimonga#buffer#impl#content(buf.id, lines) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction
