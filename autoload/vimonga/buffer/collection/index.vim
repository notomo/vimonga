
function! vimonga#buffer#collection#index#model(params) abort
    let host = vimonga#buffer#impl#host()
    let port = vimonga#buffer#impl#port()
    if a:params.has_index && a:params.has_db && a:params.has_coll
        let database_name = a:params.database_name
        let collection_name = a:params.collection_name
        let index_name = a:params.index_name
    elseif a:params.has_index
        let database_name = vimonga#buffer#impl#database_name()
        let collection_name = vimonga#buffer#impl#collection_name()
        let index_name = a:params.index_name
    else
        return vimonga#job#err(['index name is required'])
    endif
    let index = vimonga#model#index#new(
        \ host,
        \ port,
        \ database_name,
        \ collection_name,
        \ index_name,
    \ )
    return vimonga#job#ok(index)
endfunction

let s:filetype_new = 'vimonga-index-new'
function! vimonga#buffer#collection#index#new(collection, open_cmd) abort
    let path = vimonga#buffer#collection#indexes#path(a:collection) . '/new'
    let buf = vimonga#buffer#impl#buffer(s:filetype_new, path, a:open_cmd)
    let content = ['{', '  ', '}']
    let result = vimonga#buffer#impl#content(buf, content)
    setlocal modifiable
    return result
endfunction
