
function! vimonga#buffer#open(contents, filetype, path, open_cmd) abort
    let cursor = getpos('.')
    let buffer_id = bufnr('%')

    execute printf('%s %s', a:open_cmd, a:path)
    call s:buffer(a:contents, a:filetype)

    if buffer_id == bufnr('%')
        call setpos('.', cursor)
    endif
endfunction

function! vimonga#buffer#error(contents, open_cmd) abort
    execute printf('%s vimonga://error', a:open_cmd)
    call s:buffer(a:contents, '')
endfunction

function! vimonga#buffer#assert_filetype(...) abort
    if index(a:000, &filetype) == -1
        throw printf('&filetype must be in [%s] but actual: %s', join(a:000, ', '), &filetype)
    endif
endfunction

function! s:buffer(contents, filetype) abort
    setlocal buftype=nofile
    setlocal nobuflisted
    setlocal noswapfile

    setlocal modifiable
    let cursor = getpos('.')
    %delete _
    call setline(1, a:contents)
    call setpos('.', cursor)

    setlocal nomodifiable
    let &filetype = a:filetype
endfunction
