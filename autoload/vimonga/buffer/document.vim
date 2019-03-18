
let s:filetype = 'vimonga-doc'
function! vimonga#buffer#document#filetype() abort
    return s:filetype
endfunction

function! vimonga#buffer#document#ensure() abort
    call vimonga#buffer#impl#assert_filetype(s:filetype)
    return vimonga#model#document#new(
        \ s:document_id(),
        \ vimonga#buffer#impl#database_name(),
        \ vimonga#buffer#impl#collection_name(),
    \ )
endfunction

function! vimonga#buffer#document#ensure_id() abort
    call vimonga#buffer#impl#assert_filetype(
        \ s:filetype,
        \ vimonga#buffer#documents#filetype(),
    \ )
    if &filetype == s:filetype
        let document_id = s:document_id()
    else
        let document_id = vimonga#buffer#documents#get_id()
        if empty(document_id)
            throw 'object id is not found in this buffer'
        endif
    endif
    return vimonga#model#document#new(
        \ document_id,
        \ vimonga#buffer#impl#database_name(),
        \ vimonga#buffer#impl#collection_name(),
    \ )
endfunction

function! vimonga#buffer#document#open(funcs, open_cmd) abort
    let [result, err] = vimonga#buffer#impl#execute(a:funcs)
    if !empty(err)
        return vimonga#buffer#impl#error(err, a:open_cmd)
    endif
    call vimonga#buffer#impl#buffer(result['body'], s:filetype, result['path'], a:open_cmd)

    augroup vimonga_doc
        autocmd!
        autocmd BufWriteCmd <buffer> call vimonga#action#document#update()
        autocmd BufReadCmd <buffer> call vimonga#action#document#open('edit')
    augroup END

    setlocal modifiable
    setlocal buftype=acwrite
    setlocal nomodified
endfunction

let s:filetype_new = 'vimonga-doc-new'
function! vimonga#buffer#document#filetype_new() abort
    return s:filetype_new
endfunction

function! vimonga#buffer#document#new(path, open_cmd) abort
    let content = ['{', '  ', '}']
    call vimonga#buffer#impl#buffer(content, s:filetype_new, a:path, a:open_cmd)
    setlocal modifiable
endfunction

function! vimonga#buffer#document#ensure_new() abort
    call vimonga#buffer#impl#assert_filetype(s:filetype_new)
    return vimonga#model#document#new_draft(
        \ vimonga#buffer#impl#database_name(),
        \ vimonga#buffer#impl#collection_name(),
    \ )
endfunction

let s:filetype_delete = 'vimonga-doc-delete'
function! vimonga#buffer#document#filetype_delete() abort
    return s:filetype_delete
endfunction

function! s:document_id() abort
    return matchstr(bufname('%'), '\vvimonga:\/\/.*\/dbs\/[^/]*\/colls\/[^/]*\/docs\/\zs[^/]*\ze')
endfunction
