
let s:filetype = 'vimonga-colls'
function! vimonga#buffer#collections#filetype() abort
    return s:filetype
endfunction

function! vimonga#buffer#collections#ensure() abort
    call vimonga#buffer#impl#assert_filetype(s:filetype)
    return vimonga#model#collection#new(
        \ vimonga#buffer#impl#database_name(),
        \ getline(line('.')),
    \ )
endfunction

function! vimonga#buffer#collections#ensure_name() abort
    call vimonga#buffer#impl#assert_filetype(
        \ s:filetype,
        \ vimonga#buffer#collections#filetype(),
        \ vimonga#buffer#indexes#filetype(),
        \ vimonga#buffer#documents#filetype(),
        \ vimonga#buffer#document#filetype(),
        \ vimonga#buffer#document#filetype_new(),
        \ vimonga#buffer#document#filetype_delete(),
    \ )
    if &filetype == s:filetype
        let collection_name = getline(line('.'))
    else
        let collection_name = vimonga#buffer#impl#collection_name()
    endif
    return vimonga#model#collection#new(
        \ vimonga#buffer#impl#database_name(),
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
        autocmd BufReadCmd <buffer> call vimonga#action#collections#list('edit')
    augroup END
endfunction
