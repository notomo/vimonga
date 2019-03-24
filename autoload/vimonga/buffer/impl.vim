
function! vimonga#buffer#impl#error(contents, open_cmd) abort
    call vimonga#buffer#impl#buffer(a:contents, '', 'vimonga://error', a:open_cmd)
endfunction

function! vimonga#buffer#impl#assert_filetype(...) abort
    if index(a:000, &filetype) == -1
        throw printf('&filetype must be in [%s] but actual: %s', join(a:000, ', '), &filetype)
    endif
endfunction

function! vimonga#buffer#impl#buffer(filetype, path, open_cmd) abort
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

function! vimonga#buffer#impl#execute(funcs) abort
    let result = []
    for F in a:funcs
        let [result, err] = F()
        if !empty(err)
            return [[], err]
        endif
    endfor
    return [result, []]
endfunction
