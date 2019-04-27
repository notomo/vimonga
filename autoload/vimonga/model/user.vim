
function! vimonga#model#user#new(host, database_name, name) abort
    let user = {
        \ 'host': a:host,
        \ 'database_name': a:database_name,
        \ 'name': a:name,
    \ }

    function! user.database() abort
        return vimonga#model#database#new(self.host, self.database_name)
    endfunction

    return user
endfunction
