
function! vimonga#execute(arg_string) abort
    if a:arg_string ==# 'database'
        call vimonga#buffer#database#action_open('tabedit')
        return
    endif

    throw 'invalid argument: ' . a:arg_string
endfunction

let s:actions = {
    \ 'database': {
        \ 'open': { -> vimonga#buffer#collection#action_open_list('edit') },
        \ 'tab_open': { -> vimonga#buffer#collection#action_open_list('tabedit') },
    \ },
    \ 'collection': {
        \ 'open': { -> vimonga#buffer#document#action_find('edit') },
        \ 'tab_open': { -> vimonga#buffer#document#action_find('tabedit') },
        \ 'open_parent': { -> vimonga#buffer#database#action_open('edit') },
        \ 'open_indexes': { -> vimonga#buffer#index#action_list('edit') },
    \ },
    \ 'indexes': {
        \ 'open_parent': { -> vimonga#buffer#collection#action_open_from_child('edit') },
    \ },
    \ 'document': {
        \ 'open_parent': { -> vimonga#buffer#collection#action_open_from_child('edit') },
        \ 'open_next': { -> vimonga#buffer#document#action_move_page('edit', 1) },
        \ 'open_prev': { -> vimonga#buffer#document#action_move_page('edit', -1) },
    \ },
\ }
function! vimonga#action(namespace, action_name) abort
    if !has_key(s:actions, a:namespace)
        throw printf('`%s` does not exist in actions.', a:namespace)
    endif
    if !has_key(s:actions[a:namespace], a:action_name)
        throw printf('`%s` does not exist in %s actions.', a:action_name, a:namespace)
    endif

    call s:actions[a:namespace][a:action_name]()
endfunction
