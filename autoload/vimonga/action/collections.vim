
function! vimonga#action#collections#drop(params) abort
    call vimonga#job#new()
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
    call vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#databases#model(a:params) })
        \.map_ok({ database -> vimonga#buffer#collections#open(database, a:params.open_cmd) })
        \.map_extend_ok({ buf -> vimonga#repo#collection#list(buf.database) })
        \.map_ok({ buf, result -> vimonga#buffer#impl#content(buf.id, result['body']) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction

function! vimonga#action#collections#create(params) abort
    let database = vimonga#buffer#databases#model(a:params)
    let collection_name = input('Create: ')
    if empty(collection_name)
        redraw | echomsg 'Canceled' | return
    endif

    let funcs = [
        \ { -> vimonga#repo#collection#create(database.collection(collection_name))},
        \ { -> vimonga#repo#collection#list(database)},
    \ ]
    call vimonga#buffer#collections#open(funcs, a:params.open_cmd)
endfunction
