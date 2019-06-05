
function! vimonga#action#connections#list(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#connections#open(a:params.open_cmd) })
        \.map_extend_ok({ _ -> vimonga#repo#connection#list() })
        \.map_ok({ buf, lines -> vimonga#buffer#impl#content(buf, lines) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction
