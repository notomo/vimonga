
function! vimonga#complete#get(current_arg, line, cursor_position) abort
    let [_, params] = vimonga#command#parse(a:line)

    if params.has_host
        let host = params.host
    else
        let host = vimonga#config#get('default_host')
    endif

    let current_args = split(a:line, '\v\s+')[1:]
    let args = [
        \ 'RUST_BACKTRACE=1',
        \ shellescape(vimonga#config#get('executable')),
        \ 'complete',
        \ vimonga#repo#impl#option('host', host),
        \ vimonga#repo#impl#option('current', a:current_arg),
        \ join(map(current_args, { _, arg -> vimonga#repo#impl#option('args', arg) }), ' '),
        \ 'vimonga',
    \ ]
    let cmd = join(args, ' ')
    return system(cmd)
endfunction
