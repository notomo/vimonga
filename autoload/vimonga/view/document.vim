
function! vimonga#view#document#count() abort
    return s:get_option('count')
endfunction

function! vimonga#view#document#first() abort
    return s:get_option('first_number')
endfunction

function! vimonga#view#document#last() abort
    return s:get_option('last_number')
endfunction

function! vimonga#view#document#is_first() abort
    return s:get_option('is_first')
endfunction

function! vimonga#view#document#is_last() abort
    return s:get_option('is_last')
endfunction

function! s:get_option(name) abort
    if &filetype !=# vimonga#buffer#document#filetype() || !exists('b:vimonga_options')
        return ''
    endif

    return get(b:vimonga_options, a:name, '')
endfunction
