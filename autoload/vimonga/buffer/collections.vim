
let s:filetype = 'vimonga-colls'

function! vimonga#buffer#collections#model(params) abort
    if a:params.has_db && a:params.has_coll
        let database_name = a:params.database_name
        let collection_name = a:params.collection_name
    elseif &filetype == s:filetype
        let database_name = vimonga#buffer#impl#database_name()
        let collection_name = getline(line('.'))
    else
        let database_name = vimonga#buffer#impl#database_name()
        let collection_name = vimonga#buffer#impl#collection_name()
    endif
    return vimonga#model#collection#new(
        \ database_name,
        \ collection_name,
    \ )
endfunction

function! vimonga#buffer#collections#open(funcs, open_cmd) abort
    let [result, err] = vimonga#buffer#impl#execute(a:funcs)
    if !empty(err)
        return vimonga#buffer#impl#error(err, a:open_cmd)
    endif
    call vimonga#buffer#impl#buffer(result['body'], s:filetype, result['path'], a:open_cmd)

    augroup vimonga_colls
        autocmd!
        autocmd BufReadCmd <buffer> Vimonga collection.list
    augroup END
endfunction
