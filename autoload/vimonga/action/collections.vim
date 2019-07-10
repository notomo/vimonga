
function! vimonga#action#collections#drop(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#collections#model(a:params) })
        \.map_through_ok({ collection -> vimonga#message#confirm_strongly('Drop ' . collection.name . '?', a:params.force) })
        \.map_through_ok({ collection -> vimonga#repo#collection#drop(collection) })
        \.map_ok({ collection -> vimonga#buffer#collections#open(collection.database(), a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#collection#list(buf.database) })
        \.map_ok({ buf, names -> vimonga#buffer#impl#content(buf, names) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction

function! vimonga#action#collections#list(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#databases#models(a:params) })
        \.map_ok({ databases -> vimonga#buffer#collections#open(databases[0], a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#collection#list(buf.database) })
        \.map_ok({ buf, names -> vimonga#buffer#impl#content(buf, names) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction

function! vimonga#action#collections#create(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#databases#models(a:params) })
        \.map_extend_ok({ _ -> vimonga#message#input('Create: ', a:params.collection_name) })
        \.map_through_ok({ databases, name -> vimonga#repo#collection#create(databases[0].collection(name)) })
        \.map_ok({ databases, _ -> vimonga#buffer#collections#open(databases[0], a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#collection#list(buf.database) })
        \.map_ok({ buf, names -> vimonga#buffer#impl#content(buf, names) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction
