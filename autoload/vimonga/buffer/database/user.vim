
function! vimonga#buffer#database#user#model(params) abort
    let result = vimonga#buffer#databases#model(a:params)
    if result.is_err
        return result
    endif

    let name = ''
    if a:params.has_user
        let name = a:params.user_name
    endif
    if empty(name)
        return vimonga#job#err(['user name is required'])
    endif

    let [db] = result.ok
    let user = db.user(name)
    return vimonga#job#ok(user)
endfunction

let s:filetype_new = 'vimonga-user-new'
function! vimonga#buffer#database#user#new(database, open_cmd) abort
    let path = vimonga#buffer#database#users#path(a:database) . '/new'
    let buf = vimonga#buffer#impl#buffer(s:filetype_new, path, a:open_cmd)
    let content = ['{', '  "user": "",', '  "pwd": "",', '  "roles": [', '    {"role": "readWrite", "db": ""}', '  ]', '}']
    let result = vimonga#buffer#impl#content(buf, content)
    setlocal modifiable

    augroup vimonga_user_new
        autocmd!
        autocmd BufReadCmd <buffer> Vimonga user.new
    augroup END

    return result
endfunction
