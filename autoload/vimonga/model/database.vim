
function! vimonga#model#database#new(host, name) abort
    let db = {'name': a:name, 'host': a:host}

    function! db.connection() abort
        return vimonga#model#connection#new(self.host)
    endfunction

    function! db.collection(collection_name) abort
        return vimonga#model#collection#new(self.host, self.name, a:collection_name)
    endfunction

    function! db.user(user_name) abort
        return vimonga#model#user#new(self.host, self.name, a:user_name)
    endfunction

    return db
endfunction
