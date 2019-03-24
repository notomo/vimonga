
let s:filetype = 'vimonga-colls'

function! vimonga#buffer#collections#model(params) abort
    if a:params.has_db && a:params.has_coll
        let database_name = a:params.database_name
        let collection_name = a:params.collection_name
    elseif &filetype == s:filetype
        let host = vimonga#buffer#impl#host()
        let port = vimonga#buffer#impl#port()
        let database_name = vimonga#buffer#impl#database_name()
        let collection_name = getline(line('.'))
    else
        let host = vimonga#buffer#impl#host()
        let port = vimonga#buffer#impl#port()
        let database_name = vimonga#buffer#impl#database_name()
        let collection_name = vimonga#buffer#impl#collection_name()
    endif
    let coll = vimonga#model#collection#new(
        \ host,
        \ port,
        \ database_name,
        \ collection_name,
    \ )
    return vimonga#job#ok(coll)
endfunction

function! vimonga#buffer#collections#open(database, open_cmd) abort
    let path = vimonga#buffer#collections#path(a:database)
    let buf = vimonga#buffer#impl#buffer(s:filetype, path, a:open_cmd)

    augroup vimonga_colls
        autocmd!
        autocmd BufReadCmd <buffer> Vimonga collection.list
    augroup END

    return vimonga#job#ok({'id': buf, 'database': a:database})
endfunction

function! vimonga#buffer#collections#path(database) abort
    let dbs = vimonga#buffer#databases#path(a:database.connection())
    return printf('%s/%s/colls', dbs, a:database.name)
endfunction
