
function! vimonga#action#collections#drop(open_cmd) abort
    let collection = vimonga#buffer#collections#ensure()

    if input('Drop ' . collection.name . '? YES/n: ') !=# 'YES'
        redraw | echomsg 'Canceled' | return
    endif

    let funcs = [
        \ { -> vimonga#repo#collection#drop(collection)},
        \ { -> vimonga#repo#collection#list(collection.database())},
    \ ]
    call vimonga#buffer#collections#open(funcs, a:open_cmd)
endfunction

function! vimonga#action#collections#list(open_cmd) abort
    let database = vimonga#buffer#databases#ensure_name()
    let funcs = [{ -> vimonga#repo#collection#list(database)}]
    call vimonga#buffer#collections#open(funcs, a:open_cmd)
endfunction

function! vimonga#action#collections#new(open_cmd) abort
    let database = vimonga#buffer#databases#ensure_name()
    let collection_name = input('Create: ')
    if empty(collection_name)
        redraw | echomsg 'Canceled' | return
    endif

    let funcs = [
        \ { -> vimonga#repo#collection#create(database.collection(collection_name))},
        \ { -> vimonga#repo#collection#list(database)},
    \ ]
    call vimonga#buffer#collections#open(funcs, a:open_cmd)
endfunction
