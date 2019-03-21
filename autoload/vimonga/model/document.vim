
function! vimonga#model#document#new(id, database_name, collection_name) abort
    let document = {
        \ 'id': a:id,
        \ 'database_name': a:database_name,
        \ 'collection_name': a:collection_name
    \ }

    return document
endfunction
