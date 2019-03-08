
function! vimonga#execute(arg_string) abort
    if a:arg_string ==# 'database'
        call vimonga#buffer#database#list('tabedit')
        return
    endif

    throw 'invalid argument: ' . a:arg_string
endfunction

let s:actions = {
    \ 'database': {
        \ 'open': { -> vimonga#buffer#collection#list('edit') },
        \ 'tab_open': { -> vimonga#buffer#collection#list('tabedit') },
    \ },
    \ 'collection': {
        \ 'open': { -> vimonga#buffer#document#find('edit') },
        \ 'tab_open': { -> vimonga#buffer#document#find('tabedit') },
        \ 'open_parent': { -> vimonga#buffer#database#list('edit') },
        \ 'open_indexes': { -> vimonga#buffer#index#list('edit') },
        \ 'drop': { -> vimonga#buffer#collection#drop('edit') },
    \ },
    \ 'indexes': {
        \ 'open_parent': { -> vimonga#buffer#collection#open_from_child('edit') },
    \ },
    \ 'document': {
        \ 'open_parent': { -> vimonga#buffer#collection#open_from_child('edit') },
        \ 'open_next': { -> vimonga#buffer#document#move_page('edit', 1) },
        \ 'open_prev': { -> vimonga#buffer#document#move_page('edit', -1) },
        \ 'open_first': { -> vimonga#buffer#document#first('edit') },
        \ 'open_last': { -> vimonga#buffer#document#last('edit') },
        \ 'sort_ascending': { -> vimonga#buffer#document#sort#do(1, 'edit') },
        \ 'sort_descending': { -> vimonga#buffer#document#sort#do(-1, 'edit') },
        \ 'sort_toggle': { -> vimonga#buffer#documents#sort#toggle('edit') },
        \ 'sort_reset': { -> vimonga#buffer#documents#sort#do(0, 'edit') },
        \ 'sort_reset_all': { -> vimonga#buffer#documents#sort#reset_all('edit') },
        \ 'projection_hide': { -> vimonga#buffer#documents#projection#hide('edit') },
        \ 'projection_reset_all': { -> vimonga#buffer#documents#projection#reset_all('edit') },
        \ 'query_add': { -> vimonga#buffer#documents#query#add('edit') },
        \ 'query_reset_all': { -> vimonga#buffer#documents#query#reset_all('edit') },
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

let s:statuses = {
    \ 'document': {
        \ 'count': { -> vimonga#view#document#count() },
        \ 'first_number': { -> vimonga#view#document#first() },
        \ 'last_number': { -> vimonga#view#document#last() },
        \ 'is_first': { -> vimonga#view#document#is_first() },
        \ 'is_last': { -> vimonga#view#document#is_last() },
    \ },
\ }
function! vimonga#status(namespace, name) abort
    if !has_key(s:statuses, a:namespace)
        return 'INVALID_NAMESPACE'
    endif
    if !has_key(s:statuses[a:namespace], a:name)
        return 'INVALID_NAME'
    endif

    return s:statuses[a:namespace][a:name]()
endfunction
