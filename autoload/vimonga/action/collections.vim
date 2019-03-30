
function! vimonga#action#collections#drop(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#collections#model(a:params) })
        \.map_through_ok({ collection -> vimonga#message#confirm_strongly('Drop ' . collection.name . '?') })
        \.map_through_ok({ collection -> vimonga#repo#collection#drop(collection) })
        \.map_ok({ collection -> vimonga#buffer#collections#open(collection.database(), a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#collection#list(buf.database) })
        \.map_ok({ buf, result -> vimonga#buffer#impl#content(buf.id, result['body']) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction

function! vimonga#action#collections#list(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#databases#model(a:params) })
        \.map_ok({ database -> vimonga#buffer#collections#open(database, a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#collection#list(buf.database) })
        \.map_ok({ buf, result -> vimonga#buffer#impl#content(buf.id, result['body']) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction

function! vimonga#action#collections#create(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#databases#model(a:params) })
        \.map_extend_ok({ _ -> vimonga#message#input('Create: ') })
        \.map_through_ok({ database, name -> vimonga#repo#collection#create(database.collection(name)) })
        \.map_ok({ database, _ -> vimonga#buffer#collections#open(database, a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#collection#list(buf.database) })
        \.map_ok({ buf, result -> vimonga#buffer#impl#content(buf.id, result['body']) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction
