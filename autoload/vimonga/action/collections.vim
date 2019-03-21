
function! vimonga#action#collections#drop(params) abort
    let collection = vimonga#buffer#collections#model(a:params)

    if input('Drop ' . collection.name . '? YES/n: ') !=# 'YES'
        redraw | echomsg 'Canceled' | return
    endif

    let funcs = [
        \ { -> vimonga#repo#collection#drop(collection)},
        \ { -> vimonga#repo#collection#list(collection.database())},
    \ ]
    call vimonga#buffer#collections#open(funcs, a:params.open_cmd)
endfunction

function! vimonga#action#collections#list(params) abort
    let database = vimonga#buffer#databases#model(a:params)
    let funcs = [{ -> vimonga#repo#collection#list(database)}]
    call vimonga#buffer#collections#open(funcs, a:params.open_cmd)
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
