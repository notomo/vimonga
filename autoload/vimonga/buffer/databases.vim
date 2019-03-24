
let s:filetype = 'vimonga-dbs'

function! vimonga#buffer#databases#model(params) abort
    if a:params.has_db
        let name = a:params.database_name
    elseif &filetype == s:filetype
        let host = vimonga#buffer#impl#host()
        let port = vimonga#buffer#impl#port()
        let name = getline(line('.'))
    else
        let host = vimonga#buffer#impl#host()
        let port = vimonga#buffer#impl#port()
        let name = vimonga#buffer#impl#database_name()
    endif
    let db = vimonga#model#database#new(host, port, name)
    return vimonga#job#ok(db)
endfunction

function! vimonga#buffer#databases#open(connection, open_cmd) abort
    let path = vimonga#buffer#databases#path(a:connection)
    let buf =  vimonga#buffer#impl#buffer(s:filetype, path, a:open_cmd)

    augroup vimonga_dbs
        autocmd!
        autocmd BufReadCmd <buffer> Vimonga database.list
    augroup END

    return vimonga#job#ok(buf)
endfunction

function! vimonga#buffer#databases#path(connection) abort
    return printf('vimonga://%s/%s/dbs', a:connection.host, a:connection.port)
endfunction
