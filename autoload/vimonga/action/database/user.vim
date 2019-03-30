
function! vimonga#action#database#user#new(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#databases#model(a:params) })
        \.map_ok({ database -> vimonga#buffer#database#user#new(database, a:params.open_cmd) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction

function! vimonga#action#database#user#create(params) abort
    let content = join(getbufline('%', 1, '$'), '')
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#databases#model(a:params) })
        \.map_through_ok({ database -> vimonga#repo#user#create(database, content) })
        \.map_ok({ database -> vimonga#buffer#database#users#open(database, a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#user#list(buf.database) })
        \.map_ok({ buf, result -> vimonga#buffer#impl#content(buf.id, result['body']) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction

function! vimonga#action#database#user#drop(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#database#user#model(a:params) })
        \.map_through_ok({ user -> vimonga#repo#user#drop(user) })
        \.map_ok({ user -> vimonga#buffer#database#users#open(user.database(), a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#user#list(buf.database) })
        \.map_ok({ buf, result -> vimonga#buffer#impl#content(buf.id, result['body']) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction
