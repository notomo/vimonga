
let s:job_id = ''
function! vimonga#server#start() abort
    if vimonga#server#ping()
        return v:true
    endif

    let execute_cmd = vimonga#request#execute_cmd()
    let cmd = join([execute_cmd, 'server', 'start'], ' ')
    let s:job_id = jobstart(cmd)
    return v:true
endfunction

function! vimonga#server#stop() abort
    if !s:job_id
        return v:false
    endif

    try
        call jobstop(s:job_id)
        return v:true
    catch /^Vim\%((\a\+)\)\=:E900/
        return v:false
    endtry
    return v:true
endfunction

function! vimonga#server#ping() abort
    let result = vimonga#request#execute(['server', 'ping'])
    if empty(result)
        return v:false
    endif
    return result[0] ==# 'pong'
endfunction
