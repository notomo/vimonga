
function! vimonga#action#users#list(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#databases#models(a:params) })
        \.map_ok({ databases -> vimonga#buffer#users#open(databases[0], a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#user#list(buf.database) })
        \.map_ok({ buf, lines -> vimonga#buffer#impl#content(buf, lines) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction
