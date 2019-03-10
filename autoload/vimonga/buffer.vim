let s:filetype_databases = 'vimonga-db'
function! vimonga#buffer#ensure_databases() abort
    call s:assert_filetype(s:filetype_databases)
    return {
        \ 'database_name': getline(line('.')),
    \ }
endfunction

function! vimonga#buffer#ensure_database_name() abort
    call s:assert_filetype(s:filetype_databases, s:filetype_collections, s:filetype_indexes, s:filetype_documents)
    if &filetype == s:filetype_databases
        return {'database_name': getline(line('.'))}
    endif
    return {'database_name': s:database_name()}
endfunction

function! vimonga#buffer#open_databases(funcs, open_cmd) abort
    let [result, err] = s:execute(a:funcs)
    if !empty(err)
        return s:error(err, a:open_cmd)
    endif
    call s:buffer(result['body'], s:filetype_databases, result['path'], a:open_cmd)
endfunction

let s:filetype_collections = 'vimonga-coll'
function! vimonga#buffer#ensure_collections() abort
    call s:assert_filetype(s:filetype_collections)
    return {
        \ 'database_name': s:database_name(),
        \ 'collection_name': getline(line('.')),
    \ }
endfunction

function! vimonga#buffer#open_collections(funcs, open_cmd) abort
    let [result, err] = s:execute(a:funcs)
    if !empty(err)
        return s:error(err, a:open_cmd)
    endif
    call s:buffer(result['body'], s:filetype_collections, result['path'], a:open_cmd)
endfunction

let s:filetype_indexes = 'vimonga-indexes'
function! vimonga#buffer#ensure_indexes() abort
    call s:assert_filetype(s:filetype_indexes)
    return {
        \ 'database_name': s:database_name(),
        \ 'collection_name': s:collection_name(),
    \ }
endfunction

function! vimonga#buffer#open_indexes(funcs, open_cmd) abort
    let [result, err] = s:execute(a:funcs)
    if !empty(err)
        return s:error(err, a:open_cmd)
    endif
    call s:buffer(result['body'], s:filetype_indexes, result['path'], a:open_cmd)
endfunction

let s:filetype_documents = 'vimonga-doc'
function! vimonga#buffer#ensure_documents() abort
    call s:assert_filetype(s:filetype_documents)
    return {
        \ 'database_name': s:database_name(),
        \ 'collection_name': s:collection_name(),
    \ }
endfunction

function! vimonga#buffer#open_documents(funcs, open_cmd, options) abort
    let [result, err] = s:execute(a:funcs)
    if !empty(err)
        return s:error(err, a:open_cmd)
    endif
    call s:buffer(result['body'], s:filetype_documents, result['path'], a:open_cmd)

    let b:vimonga_options = a:options
    let b:vimonga_options['limit'] = result['limit']
    let b:vimonga_options['is_first'] = result['offset'] == 0
    let b:vimonga_options['is_last'] = result['is_last'] ==# 'true'
    let b:vimonga_options['first_number'] = result['first_number']
    let b:vimonga_options['last_number'] = result['last_number']
    let b:vimonga_options['count'] = result['count']
endfunction

function! s:error(contents, open_cmd) abort
    call s:buffer(a:contents, '', 'vimonga://error', a:open_cmd)
endfunction

function! s:assert_filetype(...) abort
    if index(a:000, &filetype) == -1
        throw printf('&filetype must be in [%s] but actual: %s', join(a:000, ', '), &filetype)
    endif
endfunction

function! s:buffer(contents, filetype, path, open_cmd) abort
    let before_cursor = getpos('.')
    let buffer_id = bufnr('%')

    execute printf('%s %s', a:open_cmd, a:path)

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

    if buffer_id == bufnr('%')
        call setpos('.', before_cursor)
    endif
endfunction

function! s:database_name() abort
    return matchstr(bufname('%'), '\vvimonga:\/\/.*\/dbs\/\zs[^/]*\ze')
endfunction

function! s:collection_name() abort
    return matchstr(bufname('%'), '\vvimonga:\/\/.*\/dbs\/[^/]*\/colls\/\zs[^/]*\ze')
endfunction

function! s:execute(funcs) abort
    let result = []
    for F in a:funcs
        let [result, err] = F()
        if !empty(err)
            return [[], err]
        endif
    endfor
    return [result, []]
endfunction
