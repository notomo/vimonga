
function! vimonga#model#index#new(host, database_name, collection_name, name) abort
    let index = {
        \ 'host': a:host,
        \ 'database_name': a:database_name,
        \ 'collection_name': a:collection_name,
        \ 'name': a:name,
    \ }

    function! index.collection() abort
        return vimonga#model#collection#new(self.host, self.database_name, self.collection_name)
    endfunction

    return index
endfunction
