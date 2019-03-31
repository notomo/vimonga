
let s:filetype = 'vimonga-doc'

function! vimonga#buffer#document#model(params) abort
    if a:params.has_db && a:params.has_coll && a:params.has_id
        let database_name = a:params.database_name
        let collection_name = a:params.collection_name
        let document_id = a:params.document_id
    elseif &filetype == s:filetype
        let host = vimonga#buffer#impl#host()
        let port = vimonga#buffer#impl#port()
        let database_name = vimonga#buffer#impl#database_name()
        let collection_name = vimonga#buffer#impl#collection_name()
        let document_id = vimonga#buffer#impl#document_id()
    else
        let host = vimonga#buffer#impl#host()
        let port = vimonga#buffer#impl#port()
        let database_name = vimonga#buffer#impl#database_name()
        let collection_name = vimonga#buffer#impl#collection_name()
        let document_id = vimonga#buffer#documents#get_id()
        if empty(document_id)
            return vimonga#job#err(['object id is not found in this buffer'])
        endif
    endif
    let doc = vimonga#model#document#new(
        \ host,
        \ port,
        \ document_id,
        \ database_name,
        \ collection_name,
    \ )
    return vimonga#job#ok(doc)
endfunction

function! vimonga#buffer#document#open(document, open_cmd) abort
    let path = vimonga#buffer#document#path(a:document)
    let buf = vimonga#buffer#impl#buffer(s:filetype, path, a:open_cmd)

    augroup vimonga_doc
        autocmd!
        autocmd BufWriteCmd <buffer> Vimonga document.one.update
        autocmd BufReadCmd <buffer> Vimonga document.one
    augroup END

    return vimonga#job#ok({'id': buf, 'document': a:document})
endfunction

function! vimonga#buffer#document#path(document) abort
    let docs = vimonga#buffer#documents#path(a:document.collection())
    return printf('%s/%s', docs, a:document.id)
endfunction

function! vimonga#buffer#document#content(buffer, result) abort
    let result = vimonga#buffer#impl#content(a:buffer, a:result)
    call nvim_buf_set_option(a:buffer, 'modifiable', v:true)
    call nvim_buf_set_option(a:buffer, 'buftype', 'acwrite')
    call nvim_buf_set_option(a:buffer, 'modified', v:false)
    return result
endfunction

let s:filetype_new = 'vimonga-doc-new'
function! vimonga#buffer#document#new(collection, open_cmd) abort
    let path = vimonga#buffer#documents#path(a:collection) . '/new'
    let buf = vimonga#buffer#impl#buffer(s:filetype_new, path, a:open_cmd)
    let content = ['{', '  ', '}']
    let result = vimonga#buffer#impl#content(buf, content)
    setlocal modifiable
    return result
endfunction

let s:filetype_delete = 'vimonga-doc-delete'

function! vimonga#buffer#document#open_deleted(buffer, document) abort
    execute printf('autocmd! vimonga_doc * <buffer=%s>', a:buffer)
    call nvim_buf_set_option(a:buffer, 'modifiable', v:false)
    call nvim_buf_set_option(a:buffer, 'buftype', 'nofile')
    call nvim_buf_set_option(a:buffer, 'modified', v:false)
    call nvim_buf_set_option(a:buffer, 'filetype', s:filetype_delete)
    return vimonga#job#ok([])
endfunction
