
function! vimonga#model#database#new(name) abort
    let db = {'name': a:name}

    function! db.collection(collectio_name) abort
        return vimonga#model#collection#new(self.name, a:collectio_name)
    endfunction

    return db
endfunction
