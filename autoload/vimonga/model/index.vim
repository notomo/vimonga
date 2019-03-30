
function! vimonga#model#index#new(host, port, database_name, collection_name, name) abort
    let index = {
        \ 'host': a:host,
        \ 'port': a:port,
        \ 'database_name': a:database_name,
        \ 'collection_name': a:collection_name,
        \ 'name': a:name,
    \ }

    function! index.collection() abort
        return vimonga#model#collection#new(self.host, self.port, self.database_name, self.collection_name)
    endfunction

    return index
endfunction
