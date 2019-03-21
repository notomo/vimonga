
function! vimonga#buffer#impl#error(contents, open_cmd) abort
    call vimonga#buffer#impl#buffer(a:contents, '', 'vimonga://error', a:open_cmd)
endfunction

function! vimonga#buffer#impl#assert_filetype(...) abort
    if index(a:000, &filetype) == -1
        throw printf('&filetype must be in [%s] but actual: %s', join(a:000, ', '), &filetype)
    endif
endfunction

function! vimonga#buffer#impl#buffer(contents, filetype, path, open_cmd) abort
    let before_cursor = getpos('.')
    let buffer_id = bufnr('%')

    execute printf('%s %s', a:open_cmd, a:path)

    setlocal buftype=nofile
    setlocal nobuflisted
    setlocal noswapfile

    setlocal modifiable
    let cursor = getpos('.')
    silent %delete _
    call setline(1, a:contents)
    call setpos('.', cursor)

    setlocal nomodifiable
    let &filetype = a:filetype

    if buffer_id == bufnr('%')
        call setpos('.', before_cursor)
    endif
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
