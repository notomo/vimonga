
let s:filetype = 'vimonga-dbs'

function! vimonga#buffer#databases#models(params) abort
    let result = vimonga#buffer#connections#model(a:params)
    if result.is_err
        return result
    endif

    if a:params.has_db
        let names = a:params.database_names
    elseif &filetype == s:filetype
        let names = getline(a:params.first_line, a:params.last_line)
    else
        let names = [vimonga#buffer#impl#database_name()]
    endif

    call filter(names, {_, name -> !empty(name)})

    if empty(names)
        return vimonga#job#err(['database name is required'])
    endif

    let [conn] = result.ok
    let dbs = map(names, {_, name -> conn.database(name)})
    return vimonga#job#ok(dbs)
endfunction

function! vimonga#buffer#databases#open(connection, open_cmd) abort
    let path = vimonga#buffer#databases#path(a:connection)
    let [buf, cursor] =  vimonga#buffer#impl#buffer(s:filetype, path, a:open_cmd)

    augroup vimonga_dbs
        autocmd!
        autocmd BufReadCmd <buffer> Vimonga database.list
    augroup END

    return vimonga#job#ok({'id': buf, 'connection': a:connection, 'cursor': cursor})
endfunction

function! vimonga#buffer#databases#path(connection) abort
    let conns = vimonga#buffer#connections#path()
    return printf('%s/%s/dbs', conns, a:connection.host)
endfunction
