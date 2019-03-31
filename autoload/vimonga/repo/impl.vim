
function! vimonga#repo#impl#execute(args, ...) abort
    let host = vimonga#config#get('default_host')
    let port = vimonga#config#get('default_port')

    let default_args = [
        \ 'RUST_BACKTRACE=1',
        \ shellescape(vimonga#config#get('executable')),
        \ vimonga#repo#impl#option('host', host),
        \ vimonga#repo#impl#option('port', port)
    \ ]

    let cmd = join(default_args + a:args, ' ')
    let options = {}
    if !empty(a:000)
        let options = {'handle_ok': a:000[0]} 
    endif
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
