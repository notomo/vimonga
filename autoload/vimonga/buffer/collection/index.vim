
let s:filetype_new = 'vimonga-index-new'
function! vimonga#buffer#collection#index#new(collection, open_cmd) abort
    let path = vimonga#buffer#collection#indexes#path(a:collection) . '/new'
    let buf = vimonga#buffer#impl#buffer(s:filetype_new, path, a:open_cmd)
    let content = ['{', '  ', '}']
    let result = vimonga#buffer#impl#content(buf, content)
    setlocal modifiable
    return result
endfunction
