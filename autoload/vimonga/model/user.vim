
function! vimonga#model#user#new(host, port, database_name, name) abort
    let user = {
        \ 'host': a:host,
        \ 'port': a:port,
        \ 'database_name': a:database_name,
        \ 'name': a:name,
    \ }

    function! user.database() abort
        return vimonga#model#database#new(self.host, self.port, self.database_name)
    endfunction

    return user
endfunction
