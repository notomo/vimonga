
function! vimonga#buffer#impl#buffer(filetype, path, open_cmd) abort
    if bufname('%') ==# a:path && &modified
        return
    endif
    execute printf('%s %s', a:open_cmd, a:path)

    let buf = bufnr('%')
    setlocal modifiable
    call nvim_buf_set_lines(buf, 0, line('$'), v:false, [])

    setlocal buftype=nofile
    setlocal nobuflisted
    setlocal noswapfile
    setlocal nomodifiable
    let &filetype = a:filetype

    return buf
endfunction

function! vimonga#buffer#impl#content(buffer, content) abort
    call nvim_buf_set_option(a:buffer, 'modifiable', v:true)
    call nvim_buf_set_lines(a:buffer, 0, len(a:content), v:false, a:content)
    call nvim_buf_set_option(a:buffer, 'modifiable', v:false)
    return vimonga#job#ok([])
endfunction

function! vimonga#buffer#impl#host() abort
    return matchstr(bufname('%'), '\vvimonga:\/\/\zs[^/]*\ze')
endfunction

function! vimonga#buffer#impl#port() abort
    return matchstr(bufname('%'), '\vvimonga:\/\/[^/]*\/\zs[^/]*\ze')
endfunction

function! vimonga#buffer#impl#database_name() abort
    return matchstr(bufname('%'), '\vvimonga:\/\/.*\/dbs\/\zs[^/]*\ze')
endfunction

function! vimonga#buffer#impl#collection_name() abort
    return matchstr(bufname('%'), '\vvimonga:\/\/.*\/dbs\/[^/]*\/colls\/\zs[^/]*\ze')
endfunction

function! vimonga#buffer#impl#document_id() abort
    return matchstr(bufname('%'), '\vvimonga:\/\/.*\/dbs\/[^/]*\/colls\/[^/]*\/docs\/\zs[^/]*\ze')
endfunction
