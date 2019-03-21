
let s:filetype = 'vimonga-dbs'

function! vimonga#buffer#databases#model(params) abort
    if a:params.has_db
        let name = a:params.database_name
    elseif &filetype == s:filetype
        let name = getline(line('.'))
    else
        let name = vimonga#buffer#impl#database_name()
    endif
    return vimonga#model#database#new(name)
endfunction

function! vimonga#buffer#databases#open(funcs, open_cmd) abort
    let [result, err] = vimonga#buffer#impl#execute(a:funcs)
    if !empty(err)
        return vimonga#buffer#impl#error(err, a:open_cmd)
    endif
    call vimonga#buffer#impl#buffer(result['body'], s:filetype, result['path'], a:open_cmd)

    augroup vimonga_dbs
        autocmd!
        autocmd BufReadCmd <buffer> Vimonga database.list
    augroup END
endfunction
