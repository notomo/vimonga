
function! vimonga#request#execute(args) abort
    let host = vimonga#config#get('default_host')
    let port = vimonga#config#get('default_port')
    let default_args = [
        \ 'RUST_BACKTRACE=1',
        \ 'vimonga',
        \ vimonga#request#option('pid', getpid()),
        \ vimonga#request#option('host', host),
        \ vimonga#request#option('port', port)
    \ ]

    let cmd = join(default_args + a:args, ' ')
    return systemlist(cmd)
endfunction

function! vimonga#request#option(key, value) abort
    return '--' . a:key . '=' . shellescape(a:value)
endfunction
