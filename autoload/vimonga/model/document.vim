
function! vimonga#model#document#new(id, database_name, collection_name) abort
    let document = {
        \ 'id': a:id,
        \ 'database_name': a:database_name,
        \ 'collection_name': a:collection_name
    \ }

    return document
endfunction

function! vimonga#model#document#new_draft(database_name, collection_name) abort
    let document = {
        \ 'database_name': a:database_name,
        \ 'collection_name': a:collection_name,
    \ }

    function! document.document(id) abort
        return vimonga#model#document#new(a:id, self.database_name, self.collection_name)
    endfunction

    return document
endfunction
