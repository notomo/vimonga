
function! vimonga#action#user#new(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#databases#model(a:params) })
        \.map_ok({ database -> vimonga#buffer#user#new(database, a:params.open_cmd) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction

function! vimonga#action#user#create(params) abort
    let content = join(getbufline('%', 1, '$'), '')
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#databases#model(a:params) })
        \.map_through_ok({ database -> vimonga#repo#user#create(database, content) })
        \.map_ok({ database -> vimonga#buffer#users#open(database, a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#user#list(buf.database) })
        \.map_ok({ buf, lines -> vimonga#buffer#impl#content(buf, lines) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction

function! vimonga#action#user#drop(params) abort
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#user#model(a:params) })
        \.map_through_ok({ user -> vimonga#repo#user#drop(user) })
        \.map_ok({ user -> vimonga#buffer#users#open(user.database(), a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#user#list(buf.database) })
        \.map_ok({ buf, lines -> vimonga#buffer#impl#content(buf, lines) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction
