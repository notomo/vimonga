function! vimonga#buffer#open_databases(repo, open_cmd) abort
    let filetype = vimonga#buffer#database#filetype()
    call s:buffer(a:repo['body'], filetype, a:repo['path'], a:open_cmd)
endfunction

function! vimonga#buffer#open_collections(repo, open_cmd) abort
    let filetype = vimonga#buffer#collection#filetype()
    call s:buffer(a:repo['body'], filetype, a:repo['path'], a:open_cmd)
endfunction

function! vimonga#buffer#open_indexes(repo, open_cmd) abort
    let filetype = vimonga#buffer#index#filetype()
    call s:buffer(a:repo['body'], filetype, a:repo['path'], a:open_cmd)
endfunction

function! vimonga#buffer#open_documents(repo, open_cmd, options) abort
    let filetype = vimonga#buffer#document#filetype()
    call s:buffer(a:repo['body'], filetype, a:repo['path'], a:open_cmd)

    let b:vimonga_options = a:options
    let b:vimonga_options['limit'] = a:repo['limit']
    let b:vimonga_options['is_first'] = a:repo['offset'] == 0
    let b:vimonga_options['is_last'] = a:repo['is_last'] ==# 'true'
    let b:vimonga_options['first_number'] = a:repo['first_number']
    let b:vimonga_options['last_number'] = a:repo['last_number']
    let b:vimonga_options['count'] = a:repo['count']
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
