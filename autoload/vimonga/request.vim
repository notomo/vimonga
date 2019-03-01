
function! vimonga#request#execute(args) abort
    let host = vimonga#config#get('default_host')
    let port = vimonga#config#get('default_port')
    let default_args = [
        \ 'RUST_BACKTRACE=1',
        \ vimonga#request#execute_cmd(),
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

function! vimonga#request#number_option() abort
    return vimonga#request#option('number', line('.') - 1)
endfunction

let s:pid_option = vimonga#request#option('pid', getpid())
function! vimonga#request#pid_option() abort
    return s:pid_option
endfunction

function! vimonga#request#execute_cmd() abort
    let executable = shellescape(vimonga#config#get('executable'))
    let config_path = vimonga#config#get('config_path')
    let config = vimonga#request#option('config', config_path)
    return join([executable, config], ' ')
endfunction
