
function! vimonga#action#indexes#list(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#collections#models(a:params) })
        \.map_ok({ collections -> vimonga#buffer#indexes#open(collections[0], a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#index#list(buf.collection) })
        \.map_ok({ buf, lines -> vimonga#buffer#impl#content(buf, lines) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction
