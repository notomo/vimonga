
let s:default_config = {
    \ 'default_port': '27017',
    \ 'default_host': 'localhost',
    \ 'executable': 'vimonga',
    \ 'connection_config': '~/.config/vimonga.json',
\ }
let s:config = deepcopy(s:default_config)

let s:validations = {
    \ 'default_port': {
        \ 'description': 'a positive number',
        \ 'func': {x -> type(x) ==? v:t_number && x > 0},
    \ },
    \ 'default_host': {
        \ 'description': 'a string',
        \ 'func': {x -> type(x) ==? v:t_string},
    \ },
    \ 'executable': {
        \ 'description': 'an executable string',
        \ 'func': {x -> type(x) ==? v:t_string && executable(x)},
    \ },
    \ 'connection_config': {
        \ 'description': 'a string',
        \ 'func': {x -> type(x) ==? v:t_string},
    \ },
\ }

function! vimonga#config#set(key, value) abort
    if !has_key(s:config, a:key)
        throw printf('`%s` does not exist in config options.', a:key)
    endif

    let validation = s:validations[a:key]
    if !validation['func'](a:value)
        throw printf('`%s` must be %s.', a:key, validation['description'])
    endif

    let s:config[a:key] = a:value
endfunction

function! vimonga#config#get(key) abort
    if !has_key(s:config, a:key)
        throw printf('`%s` does not exist in config options.', a:key)
    endif
    return s:config[a:key]
endfunction

function! vimonga#config#clear() abort
    let s:config = deepcopy(s:default_config)
endfunction
