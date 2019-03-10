
function! vimonga#action#collection#drop(open_cmd) abort
    let params = vimonga#buffer#ensure_collections()
    let collection_name = params['collection_name']

    if input('Drop ' . collection_name . '? YES/n: ') !=# 'YES'
        redraw | echomsg 'Canceled' | return
    endif

    let database_name = params['database_name']
    let funcs = [
        \ { -> vimonga#repo#collection#drop(database_name, collection_name)},
        \ { -> vimonga#repo#collection#list(database_name)},
    \ ]
    call vimonga#buffer#open_collections(funcs, a:open_cmd)
endfunction

function! vimonga#action#collection#list(open_cmd) abort
    let params = vimonga#buffer#ensure_database_name()
    let database_name = params['database_name']

    let funcs = [{ -> vimonga#repo#collection#list(database_name)}]
    call vimonga#buffer#open_collections(funcs, a:open_cmd)
endfunction
