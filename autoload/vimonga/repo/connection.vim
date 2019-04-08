
function! vimonga#repo#connection#list() abort
    let connection_config = expand(vimonga#config#get('connection_config'))
    if !filereadable(connection_config)
        let message = printf('could not read %s', connection_config)
        return vimonga#job#err([message])
    endif

    let connections_str = join(readfile(connection_config), '')
    try
        let connections_json = json_decode(connections_str)
    catch /^Vim\%((\a\+)\)\=:E474/
        let message = printf('invalid json: %s', connection_config)
        return vimonga#job#err([message])
    endtry

    if type(connections_json) != v:t_list
        return vimonga#job#err(['connection config must be a list json'])
    endif

    let conns = []
    for conn in connections_json
        let conn_model = vimonga#model#connection#new(conn.host, conn.port)
        call add(conns, conn_model)
    endfor
    return vimonga#job#ok(conns)
endfunction
