
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
    \ 'open': { -> vimonga#buffer#collection#action_open_list('edit') },
    \ 'tab_open': { -> vimonga#buffer#collection#action_open_list('tabedit') },
\ }
function! vimonga#database_action(action_name) abort
    if !has_key(s:database_actions, a:action_name)
        throw a:action_name . ' does not exist in database actions.'
    endif

    call s:database_actions[a:action_name]()
endfunction

let s:collection_actions = {
    \ 'open': { -> vimonga#buffer#document#action_find('edit') },
    \ 'tab_open': { -> vimonga#buffer#document#action_find('tabedit') },
    \ 'open_parent': { -> vimonga#buffer#database#action_open('edit') },
    \ 'open_indexes': { -> vimonga#buffer#index#action_list('edit') },
\ }
function! vimonga#collection_action(action_name) abort
    if !has_key(s:collection_actions, a:action_name)
        throw a:action_name . ' does not exist in collection actions.'
    endif

    call s:collection_actions[a:action_name]()
endfunction

let s:indexes_actions = {
    \ 'open_parent': { -> vimonga#buffer#collection#action_open_from_child('edit') },
\ }
function! vimonga#indexes_action(action_name) abort
    if !has_key(s:indexes_actions, a:action_name)
        throw a:action_name . ' does not exist in indexes actions.'
    endif

    call s:indexes_actions[a:action_name]()
endfunction

let s:document_actions = {
    \ 'open_parent': { -> vimonga#buffer#collection#action_open_from_child('edit') },
    \ 'open_next': { -> vimonga#buffer#document#action_move_page('edit', 1) },
    \ 'open_prev': { -> vimonga#buffer#document#action_move_page('edit', -1) },
\ }
function! vimonga#document_action(action_name) abort
    if !has_key(s:document_actions, a:action_name)
        throw a:action_name . ' does not exist in document actions.'
    endif

    call s:document_actions[a:action_name]()
endfunction
