
function! vimonga#execute(arg_string) abort
    if a:arg_string ==# 'database.list'
        call vimonga#action#databases#list('tabedit') | return
    endif

    throw 'invalid argument: ' . a:arg_string
endfunction

let s:actions = {
    \ 'database': {
        \ 'open': { -> vimonga#action#collections#list('edit') },
        \ 'tab_open': { -> vimonga#action#collections#list('tabedit') },
        \ 'drop': { -> vimonga#action#databases#drop('edit') },
    \ },
    \ 'users': {
        \ 'open': { -> vimonga#action#database#users#list('edit') },
    \ },
    \ 'collection': {
        \ 'open': { -> vimonga#action#documents#find('edit', {}) },
        \ 'tab_open': { -> vimonga#action#documents#find('tabedit', {}) },
        \ 'open_parent': { -> vimonga#action#databases#list('edit') },
        \ 'open_indexes': { -> vimonga#action#indexes#list('edit') },
        \ 'drop': { -> vimonga#action#collections#drop('edit') },
        \ 'create': { -> vimonga#action#collections#new('edit') },
    \ },
    \ 'indexes': {
        \ 'open_parent': { -> vimonga#action#collections#list('edit') },
    \ },
    \ 'document': {
        \ 'open_parent': { -> vimonga#action#collections#list('edit') },
        \ 'open_next': { -> vimonga#action#documents#move_page('edit', 1) },
        \ 'open_prev': { -> vimonga#action#documents#move_page('edit', -1) },
        \ 'open_first': { -> vimonga#action#documents#first('edit') },
        \ 'open_last': { -> vimonga#action#documents#last('edit') },
        \ 'sort_ascending': { -> vimonga#action#documents#sort#do(1, 'edit') },
        \ 'sort_descending': { -> vimonga#action#documents#sort#do(-1, 'edit') },
        \ 'sort_toggle': { -> vimonga#action#documents#sort#toggle('edit') },
        \ 'sort_reset': { -> vimonga#action#documents#sort#do(0, 'edit') },
        \ 'sort_reset_all': { -> vimonga#action#documents#sort#reset_all('edit') },
        \ 'projection_hide': { -> vimonga#action#documents#projection#hide('edit') },
        \ 'projection_reset_all': { -> vimonga#action#documents#projection#reset_all('edit') },
        \ 'query_add': { -> vimonga#action#documents#query#add('edit') },
        \ 'query_reset_all': { -> vimonga#action#documents#query#reset_all('edit') },
        \ 'open_one': { -> vimonga#action#document#open('edit') },
        \ 'tab_open_one': { -> vimonga#action#document#open('tabedit') },
        \ 'tab_new': { -> vimonga#action#document#new('tabedit') },
        \ 'insert': { -> vimonga#action#document#insert() },
        \ 'delete_one': { -> vimonga#action#document#delete() },
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
    \ 'documents': { -> vimonga#view#documents#status() },
\ }
function! vimonga#status(namespace) abort
    if !has_key(s:statuses, a:namespace)
        return 'INVALID_NAMESPACE'
    endif

    return s:statuses[a:namespace]()
endfunction
