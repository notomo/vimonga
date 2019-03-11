
let s:filetype = 'vimonga-colls'
function! vimonga#buffer#collections#filetype() abort
    return s:filetype
endfunction

function! vimonga#buffer#collections#ensure() abort
    call vimonga#buffer#impl#assert_filetype(s:filetype)
    return {
        \ 'database_name': vimonga#buffer#impl#database_name(),
        \ 'collection_name': getline(line('.')),
    \ }
endfunction

function! vimonga#buffer#collections#open(funcs, open_cmd) abort
    let [result, err] = vimonga#buffer#impl#execute(a:funcs)
    if !empty(err)
        return vimonga#buffer#impl#error(err, a:open_cmd)
    endif
    call vimonga#buffer#impl#buffer(result['body'], s:filetype, result['path'], a:open_cmd)
endfunction
