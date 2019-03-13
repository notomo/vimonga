
function! vimonga#repo#impl#execute(args) abort
    let host = vimonga#config#get('default_host')
    let port = vimonga#config#get('default_port')

    let default_args = [
        \ 'RUST_BACKTRACE=1',
        \ shellescape(vimonga#config#get('executable')),
        \ vimonga#repo#impl#option('host', host),
        \ vimonga#repo#impl#option('port', port)
    \ ]

    let cmd = join(default_args + a:args, ' ')
    let result = systemlist(cmd)

    try
        let json = json_decode(result)
        let json['body'] = split(json['body'], '\%x00')
        return [json, []]
    catch /^Vim\%((\a\+)\)\=:E474/
        return [v:null, result]
    endtry
endfunction

function! vimonga#repo#impl#option(key, value) abort
    if len(a:value) == 0
        return ''
    endif
    return '--' . a:key . '=' . shellescape(a:value)
endfunction
