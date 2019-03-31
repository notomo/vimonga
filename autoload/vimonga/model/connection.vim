
function! vimonga#model#connection#new(host, port) abort
    let conn = {'host': a:host, 'port': a:port}

    function! conn.database(database_name) abort
        return vimonga#model#database#new(self.host, self.port, a:database_name)
    endfunction

    return conn
endfunction
