
function! vimonga#model#document#new(host, id, database_name, collection_name) abort
    let doc = {
        \ 'host': a:host,
        \ 'id': a:id,
        \ 'database_name': a:database_name,
        \ 'collection_name': a:collection_name
    \ }

    function! doc.collection() abort
        return vimonga#model#collection#new(self.host, self.database_name, self.collection_name)
    endfunction

    return doc
endfunction
