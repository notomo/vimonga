let s:pid = getpid()

function! vimonga#request#execute(args) abort
    let config_path = vimonga#config#get('config_path')
    let host = vimonga#config#get('default_host')
    let port = vimonga#config#get('default_port')
    let default_args = [
        \ 'RUST_BACKTRACE=1',
        \ 'vimonga',
        \ vimonga#request#option('pid', s:pid),
        \ vimonga#request#option('config', config_path),
        \ vimonga#request#option('host', host),
        \ vimonga#request#option('port', port)
    \ ]

    let cmd = join(default_args + a:args, ' ')
    return systemlist(cmd)
endfunction

function! vimonga#request#json(args) abort
    let result = vimonga#request#execute(a:args)
    try
        let json = json_decode(result)
        let json['body'] = split(json['body'], '\%x00')
        return [json, []]
    catch /^Vim\%((\a\+)\)\=:E474/
        return [v:null, result]
    endtry
endfunction

function! vimonga#request#option(key, value) abort
    if len(a:value) == 0
        return ''
    endif
    return '--' . a:key . '=' . shellescape(a:value)
endfunction
