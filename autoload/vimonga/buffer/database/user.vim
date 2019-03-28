
let s:filetype_new = 'vimonga-user-new'
function! vimonga#buffer#database#user#new(database, open_cmd) abort
    let path = vimonga#buffer#database#users#path(a:database) . '/new'
    let buf = vimonga#buffer#impl#buffer(s:filetype_new, path, a:open_cmd)
    let content = ['{', '  "user": "",', '  "pwd": "",', '  "roles": [', '    {"role": "readWrite", "db": ""}', '  ]', '}']
    let result = vimonga#buffer#impl#content(buf, content)
    setlocal modifiable
    return result
endfunction
