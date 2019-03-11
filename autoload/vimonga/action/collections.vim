
function! vimonga#action#collections#drop(open_cmd) abort
    let params = vimonga#buffer#collections#ensure()
    let collection_name = params['collection_name']

    if input('Drop ' . collection_name . '? YES/n: ') !=# 'YES'
        redraw | echomsg 'Canceled' | return
    endif

    let database_name = params['database_name']
    let funcs = [
        \ { -> vimonga#repo#collection#drop(database_name, collection_name)},
        \ { -> vimonga#repo#collection#list(database_name)},
    \ ]
    call vimonga#buffer#collections#open(funcs, a:open_cmd)
endfunction

function! vimonga#action#collections#list(open_cmd) abort
    let params = vimonga#buffer#databases#ensure_name()
    let database_name = params['database_name']

    let funcs = [{ -> vimonga#repo#collection#list(database_name)}]
    call vimonga#buffer#collections#open(funcs, a:open_cmd)
endfunction
