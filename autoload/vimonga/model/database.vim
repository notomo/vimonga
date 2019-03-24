
function! vimonga#model#database#new(host, port, name) abort
    let db = {'name': a:name, 'host': a:host, 'port': a:port}

    function! db.connection() abort
        return vimonga#model#connection#new(self.host, self.port)
    endfunction

    function! db.collection(collectio_name) abort
        return vimonga#model#collection#new(self.name, a:collectio_name)
    endfunction

    return db
endfunction
