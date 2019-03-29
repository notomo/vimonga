
function! vimonga#buffer#database#user#model(params) abort
    let host = vimonga#buffer#impl#host()
    let port = vimonga#buffer#impl#port()
    if a:params.has_user && a:params.has_db
        let database_name = a:params.database_name
        let user_name = a:params.user_name
    elseif a:params.has_user
        let database_name = vimonga#buffer#impl#database_name()
        let user_name = a:params.user_name
    else
        return vimonga#job#err(['user name is required'])
    endif
    let user = vimonga#model#user#new(
        \ host,
        \ port,
        \ database_name,
        \ user_name,
    \ )
    return vimonga#job#ok(user)
endfunction

let s:filetype_new = 'vimonga-user-new'
function! vimonga#buffer#database#user#new(database, open_cmd) abort
    let path = vimonga#buffer#database#users#path(a:database) . '/new'
    let buf = vimonga#buffer#impl#buffer(s:filetype_new, path, a:open_cmd)
    let content = ['{', '  "user": "",', '  "pwd": "",', '  "roles": [', '    {"role": "readWrite", "db": ""}', '  ]', '}']
    let result = vimonga#buffer#impl#content(buf, content)
    setlocal modifiable
    return result
endfunction
