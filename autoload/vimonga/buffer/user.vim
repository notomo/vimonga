
function! vimonga#buffer#user#model(params) abort
    let result = vimonga#buffer#databases#models(a:params)
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

    let [dbs] = result.ok
    let user = dbs[0].user(name)
    return vimonga#job#ok(user)
endfunction

let s:filetype_new = 'vimonga-user-new'
function! vimonga#buffer#user#new(database, open_cmd) abort
    let path = vimonga#buffer#users#path(a:database) . '/new'
    let [buf, cursor] = vimonga#buffer#impl#buffer(s:filetype_new, path, a:open_cmd)
    let content = ['{', '  "user": "",', '  "pwd": "",', '  "roles": [', '    {"role": "readWrite", "db": ""}', '  ]', '}']
    let result = vimonga#buffer#impl#content({'id': buf, 'cursor': cursor}, content)
    setlocal modifiable

    augroup vimonga_user_new
        autocmd!
        autocmd BufReadCmd <buffer> Vimonga user.new
    augroup END

    return result
endfunction
