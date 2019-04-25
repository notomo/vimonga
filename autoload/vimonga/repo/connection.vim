
function! vimonga#repo#connection#list() abort
    let connection_config = expand(vimonga#config#get('connection_config'))
    let file = vimonga#repo#impl#option('file', connection_config)
    return vimonga#repo#impl#execute_with_handle(['connection', 'list', file], { result -> s:decode(result) })
endfunction

function! s:decode(result) abort
    let conns = json_decode(join(a:result, ''))
    return map(conns, { _, conn -> vimonga#model#connection#new(conn.host, conn.port) })
endfunction
