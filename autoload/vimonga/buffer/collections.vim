
let s:filetype = 'vimonga-colls'

function! vimonga#buffer#collections#model(params) abort
    let result = vimonga#buffer#databases#models(a:params)
    if result.is_err
        return result
    endif

    if a:params.has_coll
        let name = a:params.collection_name
    elseif &filetype == s:filetype
        let name = getline(line('.'))
    else
        let name = vimonga#buffer#impl#collection_name()
    endif
    if empty(name)
        return vimonga#job#err(['collection name is required'])
    endif

    let [dbs] = result.ok
    let coll = dbs[0].collection(name)
    return vimonga#job#ok(coll)
endfunction

function! vimonga#buffer#collections#open(database, open_cmd) abort
    let path = vimonga#buffer#collections#path(a:database)
    let [buf, cursor] = vimonga#buffer#impl#buffer(s:filetype, path, a:open_cmd)

    augroup vimonga_colls
        autocmd!
        autocmd BufReadCmd <buffer> Vimonga collection.list
    augroup END

    return vimonga#job#ok({'id': buf, 'database': a:database, 'cursor': cursor})
endfunction

function! vimonga#buffer#collections#path(database) abort
    let dbs = vimonga#buffer#databases#path(a:database.connection())
    return printf('%s/%s/colls', dbs, a:database.name)
endfunction
