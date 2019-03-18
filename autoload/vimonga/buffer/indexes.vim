
let s:filetype = 'vimonga-indexes'
function! vimonga#buffer#indexes#filetype() abort
    return s:filetype
endfunction

function! vimonga#buffer#indexes#open(funcs, open_cmd) abort
    let [result, err] = vimonga#buffer#impl#execute(a:funcs)
    if !empty(err)
        return vimonga#buffer#impl#error(err, a:open_cmd)
    endif
    call vimonga#buffer#impl#buffer(result['body'], s:filetype, result['path'], a:open_cmd)

    augroup vimonga_indexes
        autocmd!
        autocmd BufReadCmd <buffer> call vimonga#action#indexes#list('edit')
    augroup END
endfunction
