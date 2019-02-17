
function! vimonga#databases() abort
    call vimonga#buffer#database#open_list()
endfunction

function! vimonga#collections(database_name) abort
    call vimonga#buffer#collection#open_list(a:database_name)
endfunction

function! vimonga#documents(database_name, collection_name, ...) abort
    call call('vimonga#buffer#document#find', [a:database_name, a:collection_name] + a:000)
endfunction

let s:database_actions = {
    \ 'open': 'vimonga#buffer#database#open',
\ }

function! vimonga#database_action(action_name) abort
    if !has_key(s:database_actions, a:action_name)
        throw a:action_name . ' does not exist in database actions.'
    endif

    let func_name = s:database_actions[a:action_name]
    call call(func_name, [])
endfunction

let s:collection_actions = {
    \ 'open': 'vimonga#buffer#collection#open',
\ }

function! vimonga#collection_action(action_name) abort
    if !has_key(s:collection_actions, a:action_name)
        throw a:action_name . ' does not exist in collection actions.'
    endif

    let func_name = s:collection_actions[a:action_name]
    call call(func_name, [])
endfunction
