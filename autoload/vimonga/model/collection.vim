
function! vimonga#model#collection#new(host, database_name, name) abort
    let coll = {'name': a:name, 'database_name': a:database_name, 'host': a:host}

    function! coll.database() abort
        return vimonga#model#database#new(self.host, self.database_name)
    endfunction

    function! coll.document(id) abort
        return vimonga#model#document#new(self.host, a:id, self.database_name, self.name)
    endfunction

    function! coll.index(index_name) abort
        return vimonga#model#index#new(self.host, self.database_name, self.name, a:index_name)
    endfunction

    return coll
endfunction
