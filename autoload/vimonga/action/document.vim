
function! vimonga#action#document#update(params) abort
    let content = join(getbufline('%', 1, '$'), '')
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#document#model(a:params) })
        \.map_through_ok({ document -> vimonga#repo#document#update(document, content) })
        \.map_extend_ok({ document -> vimonga#repo#document#find_by_id(document) })
        \.map_extend_ok({ document, _ -> vimonga#buffer#document#open(document, a:params.open_cmd) })
        \.map_ok({ _, result, buf  -> vimonga#buffer#document#content(buf.id, result) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction

function! vimonga#action#document#open(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#document#model(a:params) })
        \.map_ok({ document -> vimonga#buffer#document#open(document, a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#document#find_by_id(buf.document) })
        \.map_ok({ buf, result -> vimonga#buffer#document#content(buf.id, result) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction

function! vimonga#action#document#new(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#collections#model(a:params) })
        \.map_ok({ collection -> vimonga#buffer#document#new(collection, a:params.open_cmd) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction

function! vimonga#action#document#insert(params) abort
    let content = join(getbufline('%', 1, '$'), '')
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#collections#model(a:params) })
        \.map_extend_ok({ collection -> vimonga#repo#document#insert(collection, content) })
        \.map_extend_ok({ collection, id -> vimonga#repo#document#find_by_id(collection.document(id)) })
        \.map_extend_ok({ collection, id, _ -> vimonga#buffer#document#open(collection.document(id), a:params.open_cmd) })
        \.map_ok({ _, __, result, buf  -> vimonga#buffer#document#content(buf.id, result) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction

function! vimonga#action#document#delete(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#document#model(a:params) })
        \.map_through_ok({ document -> vimonga#message#confirm('Delete ' . document.id . '?', a:params.force) })
        \.map_extend_ok({ document -> vimonga#buffer#document#open(document, a:params.open_cmd) })
        \.map_through_ok({ document, _ -> vimonga#repo#document#delete(document) })
        \.map_ok({ _, buf -> vimonga#buffer#document#open_deleted(buf.id, buf.document) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction
