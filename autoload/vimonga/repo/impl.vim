
function! vimonga#repo#impl#execute(args, ...) abort
    let default_args = [
        \ 'RUST_BACKTRACE=1',
        \ shellescape(vimonga#config#get('executable')),
    \ ]

    let conn_args = []
    if len(a:000) >= 1
        let conn = a:000[0]
        let host = vimonga#repo#impl#option('host', conn.host)
        let port = vimonga#repo#impl#option('port', conn.port)
        let conn_args = [host, port]
    endif
    let cmd = join(default_args + a:args[:0] + conn_args + a:args[1:], ' ')
    let options = {}
    if len(a:000) >= 2
        let options = {'handle_ok': a:000[1]} 
    endif
    return vimonga#job#pending(cmd, options)
endfunction

function! vimonga#repo#impl#execute_with_handle(args, handle) abort
    let default_args = [
        \ 'RUST_BACKTRACE=1',
        \ shellescape(vimonga#config#get('executable')),
    \ ]
    let cmd = join(default_args + a:args, ' ')
    let options = {'handle_ok': a:handle}
    return vimonga#job#pending(cmd, options)
endfunction

function! vimonga#repo#impl#option(key, value) abort
    if len(a:value) == 0
        return ''
    endif
    return '--' . a:key . '=' . shellescape(a:value)
endfunction

function! vimonga#repo#impl#join() abort
    return { result -> join(result, '') }
endfunction

function! vimonga#repo#impl#decode() abort
    return function('s:decode')
endfunction

function! s:decode(result) abort
    let json = json_decode(join(a:result, ''))
    let json['body'] = split(json['body'], '\%x00')
    return json
endfunction
