
function! vimonga#model#connection#new(host) abort
    let conn = {'host': a:host}

    function! conn.database(database_name) abort
        return vimonga#model#database#new(self.host, a:database_name)
    endfunction

    return conn
endfunction
