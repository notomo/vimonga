
function! vimonga#action#collections#drop(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#collections#models(a:params) })
        \.map_through_ok({ collections -> vimonga#message#confirm_strongly('Drop ' . join(map(copy(collections), {_, coll -> coll.name}), ' ') . '?', a:params.force) })
        \.map_through_ok({ collections -> vimonga#repo#collection#drop(collections) })
        \.map_ok({ collections -> vimonga#buffer#collections#open(collections[0].database(), a:params.open_cmd) })
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
        \.map_extend_ok({ _ -> vimonga#message#input('Create: ', a:params.collection_names) })
        \.map_through_ok({ databases, names -> vimonga#repo#collection#create(map(names, {_, name -> databases[0].collection(name)})) })
        \.map_ok({ databases, _ -> vimonga#buffer#collections#open(databases[0], a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#collection#list(buf.database) })
        \.map_ok({ buf, names -> vimonga#buffer#impl#content(buf, names) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction
