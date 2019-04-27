
let s:filetype = 'vimonga-conns'

function! vimonga#buffer#connections#model(params) abort
    let buf_host = vimonga#buffer#impl#host()
    if a:params.has_host
        let host = a:params.host
    elseif &filetype == s:filetype && !empty(getline(line('.')))
        let host = getline(line('.'))
    elseif !empty(buf_host)
        let host = buf_host
    else
        let host = vimonga#config#get('default_host')
    endif
    if empty(host)
        return vimonga#job#err(['host is required'])
    endif

    let conn = vimonga#model#connection#new(host)
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

function! vimonga#buffer#connections#path() abort
    return 'vimonga://conns'
endfunction
