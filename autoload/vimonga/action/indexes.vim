
function! vimonga#action#indexes#list(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#collections#model(a:params) })
        \.map_ok({ collection -> vimonga#buffer#indexes#open(collection, a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#index#list(buf.collection) })
        \.map_ok({ buf, lines -> vimonga#buffer#impl#content(buf, lines) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction
