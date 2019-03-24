
function! vimonga#model#connection#new(host, port) abort
    let conn = {'host': a:host, 'port': a:port}

    return conn
endfunction
