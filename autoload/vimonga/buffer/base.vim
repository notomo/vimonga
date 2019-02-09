
function! vimonga#buffer#base#open(contents, filetype) abort
    tabnew

    setlocal buftype=nofile
    setlocal nobuflisted
    setlocal noswapfile

    call setline(1, a:contents)

    setlocal nomodifiable
    let &filetype = a:filetype
endfunction
