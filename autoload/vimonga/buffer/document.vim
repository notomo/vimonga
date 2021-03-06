
let s:filetype = 'vimonga-doc'

function! vimonga#buffer#document#model(params) abort
    let result = vimonga#buffer#collections#models(a:params)
    if result.is_err
        return result
    endif

    if a:params.has_id
        let id = a:params.document_id
    elseif &filetype == s:filetype
        let id = vimonga#buffer#impl#document_id()
    else
        let id = vimonga#buffer#documents#get_id()
    endif
    if empty(id)
        return vimonga#job#err(['document id is required'])
    endif

    let [colls] = result.ok
    let doc = colls[0].document(id)
    return vimonga#job#ok(doc)
endfunction

function! vimonga#buffer#document#open(document, open_cmd) abort
    let path = vimonga#buffer#document#path(a:document)
    let [buf, cursor] = vimonga#buffer#impl#buffer(s:filetype, path, a:open_cmd)

    augroup vimonga_doc
        autocmd!
        autocmd BufWriteCmd <buffer> Vimonga document.one.update
        autocmd BufReadCmd <buffer> Vimonga document.one
    augroup END

    return vimonga#job#ok({'id': buf, 'document': a:document, 'cursor': cursor})
endfunction

function! vimonga#buffer#document#path(document) abort
    let docs = vimonga#buffer#documents#path(a:document.collection())
    return printf('%s/%s', docs, a:document.id)
endfunction

function! vimonga#buffer#document#content(buffer, result) abort
    let result = vimonga#buffer#impl#content(a:buffer, a:result)
    call nvim_buf_set_option(a:buffer.id, 'modifiable', v:true)
    call nvim_buf_set_option(a:buffer.id, 'buftype', 'acwrite')
    call nvim_buf_set_option(a:buffer.id, 'modified', v:false)
    return result
endfunction

let s:filetype_new = 'vimonga-doc-new'
function! vimonga#buffer#document#new(collection, open_cmd) abort
    let path = vimonga#buffer#documents#path(a:collection) . '/new'
    let [buf, cursor] = vimonga#buffer#impl#buffer(s:filetype_new, path, a:open_cmd)
    let content = ['{', '  ', '}']
    let result = vimonga#buffer#impl#content({'id': buf, 'cursor': cursor}, content)
    setlocal modifiable

    augroup vimonga_doc_new
        autocmd!
        autocmd BufReadCmd <buffer> Vimonga document.new
    augroup END

    return result
endfunction

let s:filetype_delete = 'vimonga-doc-delete'

function! vimonga#buffer#document#open_deleted(buffer, document) abort
    execute printf('autocmd! vimonga_doc * <buffer=%s>', a:buffer.id)
    call nvim_buf_set_option(a:buffer.id, 'modifiable', v:false)
    call nvim_buf_set_option(a:buffer.id, 'buftype', 'nofile')
    call nvim_buf_set_option(a:buffer.id, 'modified', v:false)
    call nvim_buf_set_option(a:buffer.id, 'filetype', s:filetype_delete)
    return vimonga#job#ok([])
endfunction
