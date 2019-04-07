
function! vimonga#buffer#connections#model(params) abort
    let [buf_host, buf_port] = vimonga#buffer#impl#host_port()
    if a:params.has_host
        let host = a:params.host
    elseif !empty(buf_host)
        let host = buf_host
    else
        let host = vimonga#config#get('default_host')
    endif
    if a:params.has_port
        let port = a:params.port
    elseif !empty(buf_port)
        let port = buf_port
    else
        let port = vimonga#config#get('default_port')
    endif
    if empty(host) || empty(port)
        return vimonga#job#err(['host and port are required'])
    endif

    let conn = vimonga#model#connection#new(host, port)
    return vimonga#job#ok(conn)
endfunction
