
function! vimonga#action#index#new(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#collections#model(a:params) })
        \.map_ok({ collection -> vimonga#buffer#index#new(collection, a:params.open_cmd) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction

function! vimonga#action#index#create(params) abort
    let content = join(getbufline('%', 1, '$'), '')
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#collections#model(a:params) })
        \.map_through_ok({ collection -> vimonga#repo#index#create(collection, content) })
        \.map_ok({ collection -> vimonga#buffer#indexes#open(collection, a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#index#list(buf.collection) })
        \.map_ok({ buf, lines -> vimonga#buffer#impl#content(buf.id, lines) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction

function! vimonga#action#index#drop(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#index#model(a:params) })
        \.map_through_ok({ index -> vimonga#repo#index#drop(index) })
        \.map_ok({ index -> vimonga#buffer#indexes#open(index.collection(), a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#index#list(buf.collection) })
        \.map_ok({ buf, lines -> vimonga#buffer#impl#content(buf.id, lines) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction
