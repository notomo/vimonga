
function! vimonga#start() abort
    let db_names = systemlist('vimonga')

    tabnew
    setlocal buftype=nofile
    setlocal nobuflisted
    setlocal noswapfile

    call setline(1, db_names)
endfunction
