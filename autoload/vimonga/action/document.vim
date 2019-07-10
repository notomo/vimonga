
function! vimonga#action#document#update(params) abort
    let content = join(getbufline('%', 1, '$'), '')
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#document#model(a:params) })
        \.map_through_ok({ document -> vimonga#repo#document#update(document, content) })
        \.map_extend_ok({ document -> vimonga#repo#document#find_by_id(document) })
        \.map_extend_ok({ document, _ -> vimonga#buffer#document#open(document, a:params.open_cmd) })
        \.map_ok({ _, result, buf  -> vimonga#buffer#document#content(buf, result) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction

function! vimonga#action#document#open(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#document#model(a:params) })
        \.map_ok({ document -> vimonga#buffer#document#open(document, a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#document#find_by_id(buf.document) })
        \.map_ok({ buf, result -> vimonga#buffer#document#content(buf, result) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction

function! vimonga#action#document#new(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#collections#models(a:params) })
        \.map_ok({ collections -> vimonga#buffer#document#new(collections[0], a:params.open_cmd) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction

function! vimonga#action#document#insert(params) abort
    let content = join(getbufline('%', 1, '$'), '')
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#collections#models(a:params) })
        \.map_extend_ok({ collections -> vimonga#repo#document#insert(collections[0], content) })
        \.map_extend_ok({ collections, id -> vimonga#repo#document#find_by_id(collections[0].document(id)) })
        \.map_extend_ok({ collections, id, _ -> vimonga#buffer#document#open(collections[0].document(id), a:params.open_cmd) })
        \.map_ok({ _, __, result, buf  -> vimonga#buffer#document#content(buf, result) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction

function! vimonga#action#document#delete(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#document#model(a:params) })
        \.map_through_ok({ document -> vimonga#message#confirm('Delete ' . document.id . '?', a:params.force) })
        \.map_extend_ok({ document -> vimonga#buffer#document#open(document, a:params.open_cmd) })
        \.map_through_ok({ document, _ -> vimonga#repo#document#delete(document) })
        \.map_ok({ _, buf -> vimonga#buffer#document#open_deleted(buf, buf.document) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction
