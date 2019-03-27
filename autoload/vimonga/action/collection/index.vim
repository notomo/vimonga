
function! vimonga#action#collection#index#new(params) abort
    call vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#collections#model(a:params) })
        \.map_ok({ collection -> vimonga#buffer#collection#index#new(collection, a:params.open_cmd) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction

function! vimonga#action#collection#index#create(params) abort
    let content = join(getbufline('%', 1, '$'), '')
    call vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#collections#model(a:params) })
        \.map_through_ok({ collection -> vimonga#repo#index#create(collection, content) })
        \.map_ok({ collection -> vimonga#buffer#collection#indexes#open(collection, a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#index#list(buf.collection) })
        \.map_ok({ buf, result -> vimonga#buffer#impl#content(buf.id, result['body']) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction
