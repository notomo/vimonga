
let s:filetype = 'vimonga-dbs'

function! vimonga#buffer#databases#model(params) abort
    let result = vimonga#buffer#connections#model(a:params)
    if result.is_err
        return result
    endif

    let [conn] = result.ok
    if a:params.has_db
        let name = a:params.database_name
    elseif &filetype == s:filetype
        let name = getline(line('.'))
    else
        let name = vimonga#buffer#impl#database_name()
    endif
    if empty(name)
        return vimonga#job#err(['database name is required'])
    endif

    let db = conn.database(name)
    return vimonga#job#ok(db)
endfunction

function! vimonga#buffer#databases#open(connection, open_cmd) abort
    let path = vimonga#buffer#databases#path(a:connection)
    let buf =  vimonga#buffer#impl#buffer(s:filetype, path, a:open_cmd)

    augroup vimonga_dbs
        autocmd!
        autocmd BufReadCmd <buffer> Vimonga database.list
    augroup END

    return vimonga#job#ok({'id': buf, 'connection': a:connection})
endfunction

function! vimonga#buffer#databases#path(connection) abort
    return printf('vimonga://%s/%s/dbs', a:connection.host, a:connection.port)
endfunction
