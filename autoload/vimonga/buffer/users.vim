
let s:filetype = 'vimonga-users'

function! vimonga#buffer#users#open(database, open_cmd) abort
    let path = vimonga#buffer#users#path(a:database)
    let buf = vimonga#buffer#impl#buffer(s:filetype, path, a:open_cmd)

    augroup vimonga_users
        autocmd!
        autocmd BufReadCmd <buffer> Vimonga user.list
    augroup END

    return vimonga#job#ok({'id': buf, 'database': a:database})
endfunction

function! vimonga#buffer#users#path(database) abort
    let dbs = vimonga#buffer#databases#path(a:database.connection())
    return printf('%s/%s/users', dbs, a:database.name)
endfunction
