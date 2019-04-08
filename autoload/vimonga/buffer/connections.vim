
let s:filetype = 'vimonga-conns'

function! vimonga#buffer#connections#model(params) abort
    let [buf_host, buf_port] = vimonga#buffer#impl#host_port()
    if a:params.has_host
        let host = a:params.host
    elseif &filetype == s:filetype && !empty(getline(line('.')))
        let line = getline(line('.'))
        let host = split(line, ':')[0]
    elseif !empty(buf_host)
        let host = buf_host
    else
        let host = vimonga#config#get('default_host')
    endif
    if a:params.has_port
        let port = a:params.port
    elseif &filetype == s:filetype && !empty(getline(line('.')))
        let line = getline(line('.'))
        let port = split(line, ':')[1]
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

function! vimonga#buffer#connections#open(open_cmd) abort
    let path = vimonga#buffer#connections#path()
    let buf = vimonga#buffer#impl#buffer(s:filetype, path, a:open_cmd)

    augroup vimonga_conns
        autocmd!
        autocmd BufReadCmd <buffer> Vimonga connection.list
    augroup END

    return vimonga#job#ok({'id': buf})
endfunction

function! vimonga#buffer#connections#content(buffer, conns) abort
    let lines = []
    for conn in a:conns
        let line = printf('%s:%s', conn.host, conn.port)
        call add(lines, line)
    endfor

    let result = vimonga#buffer#impl#content(a:buffer, lines)
    return result
endfunction

function! vimonga#buffer#connections#path() abort
    return 'vimonga://conns'
endfunction
