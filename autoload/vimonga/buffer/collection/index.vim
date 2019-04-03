
function! vimonga#buffer#collection#index#model(params) abort
    let result = vimonga#buffer#collections#model(a:params)
    if result.is_err
        return result
    endif

    let [coll] = result.ok
    if a:params.has_index
        let name = a:params.index_name
    endif
    if empty(name)
        return vimonga#job#err(['index name is required'])
    endif
    let index = coll.index(name)
    return vimonga#job#ok(index)
endfunction

let s:filetype_new = 'vimonga-index-new'
function! vimonga#buffer#collection#index#new(collection, open_cmd) abort
    let path = vimonga#buffer#collection#indexes#path(a:collection) . '/new'
    let buf = vimonga#buffer#impl#buffer(s:filetype_new, path, a:open_cmd)
    let content = ['{', '  "field": 1', '}']
    let result = vimonga#buffer#impl#content(buf, content)
    setlocal modifiable

    augroup vimonga_index_new
        autocmd!
        autocmd BufReadCmd <buffer> Vimonga index.new
    augroup END

    return result
endfunction
