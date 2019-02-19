
let s:default_config = {
    \ 'config_path': '',
    \ 'default_port': 27017,
    \ 'default_host': 'localhost',
\ }
let s:config = deepcopy(s:default_config)

let s:validations = {
    \ 'config_path': {
        \ 'description': 'a config file path',
        \ 'func': {x -> type(x) ==? v:t_string},
    \ },
    \ 'default_port': {
        \ 'description': 'a positive number',
        \ 'func': {x -> type(x) ==? v:t_number && x > 0},
    \ },
    \ 'default_host': {
        \ 'description': 'a string',
        \ 'func': {x -> type(x) ==? v:t_string},
    \ },
\ }

function! vimonga#config#set(key, value) abort
    if !has_key(s:config, a:key)
        throw a:key . ' does not exist in config options.'
    endif

    let validation = s:validations[a:key]
    if !validation['func'](a:value)
        throw a:key . ' must be ' . validation['description'] . '.'
    endif

    let s:config[a:key] = a:value
endfunction

function! vimonga#config#get(key) abort
    if !has_key(s:config, a:key)
        throw a:key . ' does not exist in config options.'
    endif
    return s:config[a:key]
endfunction

function! vimonga#config#clear() abort
    let s:config = deepcopy(s:default_config)
endfunction
