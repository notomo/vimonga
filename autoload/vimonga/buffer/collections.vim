
let s:filetype = 'vimonga-colls'

function! vimonga#buffer#collections#models(params) abort
    let result = vimonga#buffer#databases#models(a:params)
    if result.is_err
        return result
    endif

    if a:params.has_coll
        let names = a:params.collection_names
    elseif &filetype == s:filetype
        let names = getline(a:params.first_line, a:params.last_line)
    else
        let names = [vimonga#buffer#impl#collection_name()]
    endif

    call filter(names, {_, name -> !empty(name)})

    if empty(names)
        return vimonga#job#err(['collection name is required'])
    endif

    let [dbs] = result.ok
    let colls = map(names, {_, name -> dbs[0].collection(name)})
    return vimonga#job#ok(colls)
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
