
function! vimonga#model#collection#new(database_name, name) abort
    let coll = {'name': a:name, 'database_name': a:database_name}

    function! coll.database() abort
        return vimonga#model#database#new(self.database_name)
    endfunction

    return coll
endfunction
