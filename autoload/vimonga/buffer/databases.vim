let s:filetype = 'vimonga-dbs'
function! vimonga#buffer#databases#filetype() abort
    return s:filetype
endfunction

function! vimonga#buffer#databases#ensure() abort
    call vimonga#buffer#impl#assert_filetype(s:filetype)
    return vimonga#model#database#new(getline(line('.')))
endfunction

function! vimonga#buffer#databases#ensure_name() abort
    call vimonga#buffer#impl#assert_filetype(
        \ s:filetype,
        \ vimonga#buffer#database#users#filetype(),
        \ vimonga#buffer#collections#filetype(),
        \ vimonga#buffer#indexes#filetype(),
        \ vimonga#buffer#documents#filetype(),
    \ )
    if &filetype == s:filetype
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
        autocmd BufReadCmd <buffer> call vimonga#action#databases#list('edit')
    augroup END
endfunction
