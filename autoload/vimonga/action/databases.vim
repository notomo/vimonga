
function! vimonga#action#databases#list(open_cmd) abort
    let funcs = [{ -> vimonga#repo#database#list()}]
    call vimonga#buffer#databases#open(funcs, a:open_cmd)
endfunction

function! vimonga#action#databases#drop(open_cmd) abort
    let database = vimonga#buffer#databases#ensure()

    if input('Drop ' . database.name . '? YES/n: ') !=# 'YES'
        redraw | echomsg 'Canceled' | return
    endif

    let funcs = [
        \ { -> vimonga#repo#database#drop(database)},
        \ { -> vimonga#repo#database#list()},
    \ ]
    call vimonga#buffer#databases#open(funcs, a:open_cmd)
endfunction
