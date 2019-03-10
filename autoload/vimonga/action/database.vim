
function! vimonga#action#database#list(open_cmd) abort
    let funcs = [{ -> vimonga#repo#database#list()}]
    call vimonga#buffer#databases#open(funcs, a:open_cmd)
endfunction

function! vimonga#action#database#drop(open_cmd) abort
    let params = vimonga#buffer#databases#ensure()
    let database_name = params['database_name']

    if input('Drop ' . database_name . '? YES/n: ') !=# 'YES'
        redraw | echomsg 'Canceled' | return
    endif

    let funcs = [
        \ { -> vimonga#repo#database#drop(database_name)},
        \ { -> vimonga#repo#database#list()},
    \ ]
    call vimonga#buffer#databases#open(funcs, a:open_cmd)
endfunction
