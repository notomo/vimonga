
function! vimonga#view#documents#status() abort
    if !exists('b:vimonga_options')
        return {}
    endif

    return {
        \ 'first_number': get(b:vimonga_options, 'first_number', ''),
        \ 'last_number': get(b:vimonga_options, 'last_number', ''),
        \ 'is_first': get(b:vimonga_options, 'is_first', ''),
        \ 'is_last': get(b:vimonga_options, 'is_last', ''),
        \ 'count': get(b:vimonga_options, 'count', ''),
    \ }
endfunction
