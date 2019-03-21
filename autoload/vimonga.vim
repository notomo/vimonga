
let s:statuses = {
    \ 'documents': { -> vimonga#view#documents#status() },
\ }
function! vimonga#status(namespace) abort
    if !has_key(s:statuses, a:namespace)
        return 'INVALID_NAMESPACE'
    endif

    return s:statuses[a:namespace]()
endfunction
