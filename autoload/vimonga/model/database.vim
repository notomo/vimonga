
function! vimonga#model#database#new(host, port, name) abort
    let db = {'name': a:name, 'host': a:host, 'port': a:port}

    function! db.connection() abort
        return vimonga#model#connection#new(self.host, self.port)
    endfunction

    function! db.collection(collection_name) abort
        return vimonga#model#collection#new(self.host, self.port, self.name, a:collection_name)
    endfunction

    function! db.user(user_name) abort
        return vimonga#model#user#new(self.host, self.port, self.name, a:user_name)
    endfunction

    return db
endfunction
