
let s:filetype = 'vimonga-users'

function! vimonga#buffer#database#users#open(funcs, open_cmd) abort
    let [result, err] = vimonga#buffer#impl#execute(a:funcs)
    if !empty(err)
        return vimonga#buffer#impl#error(err, a:open_cmd)
    endif
    call vimonga#buffer#impl#buffer(result['body'], s:filetype, result['path'], a:open_cmd)

    augroup vimonga_colls
        autocmd!
        autocmd BufReadCmd <buffer> Vimonga user.list
    augroup END
endfunction
