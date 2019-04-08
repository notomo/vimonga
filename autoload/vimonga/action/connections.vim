
function! vimonga#action#connections#list(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#connections#open(a:params.open_cmd) })
        \.map_extend_ok({ _ -> vimonga#repo#connection#list() })
        \.map_ok({ buf, conns -> vimonga#buffer#connections#content(buf.id, conns) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction
