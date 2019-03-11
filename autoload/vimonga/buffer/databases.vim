let s:filetype = 'vimonga-dbs'
function! vimonga#buffer#databases#filetype() abort
    return s:filetype
endfunction

function! vimonga#buffer#databases#ensure() abort
    call vimonga#buffer#impl#assert_filetype(s:filetype)
    return {
        \ 'database_name': getline(line('.')),
    \ }
endfunction

function! vimonga#buffer#databases#ensure_name() abort
    call vimonga#buffer#impl#assert_filetype(
        \ s:filetype,
        \ vimonga#buffer#collections#filetype(),
        \ vimonga#buffer#indexes#filetype(),
        \ vimonga#buffer#documents#filetype(),
    \ )
    if &filetype == s:filetype
        return {'database_name': getline(line('.'))}
    endif
    return {'database_name': vimonga#buffer#impl#database_name()}
endfunction

function! vimonga#buffer#databases#open(funcs, open_cmd) abort
    let [result, err] = vimonga#buffer#impl#execute(a:funcs)
    if !empty(err)
        return vimonga#buffer#impl#error(err, a:open_cmd)
    endif
    call vimonga#buffer#impl#buffer(result['body'], s:filetype, result['path'], a:open_cmd)
endfunction
