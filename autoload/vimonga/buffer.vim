
function! vimonga#buffer#open(contents, filetype, path, open_cmd) abort
    let host = vimonga#config#get('default_host')
    let port = vimonga#config#get('default_port')
    let path = printf('vimonga://%s/%s/%s', host, port, a:path)
    let cursor = getpos('.')

    execute printf('%s %s', a:open_cmd, path)
    call s:buffer(a:contents, a:filetype)

    call setpos('.', cursor)
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
    call s:clear_buffer()
    call setline(1, a:contents)

    setlocal nomodifiable
    let &filetype = a:filetype
endfunction

function! s:clear_buffer() abort
    if has('nvim')
        call nvim_buf_set_lines(bufnr('%'), 0, line('$') - 1, v:false, [])
        return
    endif

    call deletebufline('%', 1, '$')
endfunction
