
function! vimonga#action#collection#indexes#list(params) abort
    call vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#collections#model(a:params) })
        \.map_ok({ collection -> vimonga#buffer#collection#indexes#open(collection, a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#index#list(buf.collection) })
        \.map_ok({ buf, result -> vimonga#buffer#impl#content(buf.id, result['body']) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction
