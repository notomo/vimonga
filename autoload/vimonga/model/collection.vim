
function! vimonga#model#collection#new(database_name, name) abort
    let coll = {'name': a:name, 'database_name': a:database_name}

    function! coll.database() abort
        return vimonga#model#database#new(self.database_name)
    endfunction

    function! coll.document(id) abort
        return vimonga#model#document#new(a:id, self.database_name, self.name)
    endfunction

    return coll
endfunction
