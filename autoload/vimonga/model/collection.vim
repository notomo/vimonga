
function! vimonga#model#collection#new(host, port, database_name, name) abort
    let coll = {'name': a:name, 'database_name': a:database_name, 'host': a:host, 'port': a:port}

    function! coll.database() abort
        return vimonga#model#database#new(self.host, self.port, self.database_name)
    endfunction

    function! coll.document(id) abort
        return vimonga#model#document#new(self.host, self.port, a:id, self.database_name, self.name)
    endfunction

    function! coll.index(index_name) abort
        return vimonga#model#index#new(self.host, self.port, self.database_name, self.name, a:index_name)
    endfunction

    return coll
endfunction
