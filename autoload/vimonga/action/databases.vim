
function! vimonga#action#databases#list(params) abort
    let funcs = [{ -> vimonga#repo#database#list()}]
    call vimonga#buffer#databases#open(funcs, a:params.open_cmd)
endfunction

function! vimonga#action#databases#drop(params) abort
    let database = vimonga#buffer#databases#model(a:params)

    if input('Drop ' . database.name . '? YES/n: ') !=# 'YES'
        redraw | echomsg 'Canceled' | return
    endif

    let funcs = [
        \ { -> vimonga#repo#database#drop(database)},
        \ { -> vimonga#repo#database#list()},
    \ ]
    call vimonga#buffer#databases#open(funcs, a:params.open_cmd)
endfunction
