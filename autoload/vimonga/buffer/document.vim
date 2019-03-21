
let s:filetype = 'vimonga-doc'
function! vimonga#buffer#document#filetype() abort
    return s:filetype
endfunction

function! vimonga#buffer#document#model(params) abort
    if a:params.has_db && a:params.has_coll && a:params.has_id
        let database_name = a:params.database_name
        let collection_name = a:params.collection_name
        let document_id = a:params.document_id
    elseif &filetype == s:filetype
        let database_name = vimonga#buffer#impl#database_name()
        let collection_name = vimonga#buffer#impl#collection_name()
        let document_id = s:document_id()
    else
        let database_name = vimonga#buffer#impl#database_name()
        let collection_name = vimonga#buffer#impl#collection_name()
        let document_id = vimonga#buffer#documents#get_id()
        if empty(document_id)
            throw 'object id is not found in this buffer'
        endif
    endif
    return vimonga#model#document#new(
        \ document_id,
        \ database_name,
        \ collection_name,
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
        autocmd BufWriteCmd <buffer> Vimonga document.one.update
        autocmd BufReadCmd <buffer> Vimonga document.one
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
endfunction

let s:filetype_delete = 'vimonga-doc-delete'
function! vimonga#buffer#document#filetype_delete() abort
    return s:filetype_delete
endfunction

function! s:document_id() abort
    return matchstr(bufname('%'), '\vvimonga:\/\/.*\/dbs\/[^/]*\/colls\/[^/]*\/docs\/\zs[^/]*\ze')
endfunction
