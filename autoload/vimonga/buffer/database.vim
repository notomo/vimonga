
let s:filetype = 'vimonga-db'
function! vimonga#buffer#database#filetype() abort
    return s:filetype
endfunction

function! vimonga#buffer#database#action_open(open_cmd) abort
    call s:open([], a:open_cmd)
endfunction

function! s:open(args, open_cmd) abort
    let db_names = vimonga#request#execute(['database', 'list'] + a:args)
    call vimonga#buffer#base#open(db_names, s:filetype, 'dbs', a:open_cmd)
endfunction
