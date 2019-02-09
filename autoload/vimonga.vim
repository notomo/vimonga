
function! vimonga#databases() abort
    call vimonga#buffer#database#open_list()
endfunction

function! vimonga#collections(database_name) abort
    call vimonga#buffer#collection#open_list(a:database_name)
endfunction

function! vimonga#documents(database_name, collection_name, ...) abort
    call call('vimonga#buffer#document#find', [a:database_name, a:collection_name] + a:000)
endfunction

function! vimonga#database_action(action_name) abort
    let func_name = 'vimonga#buffer#database#' . a:action_name
    call call(func_name, [])
endfunction
