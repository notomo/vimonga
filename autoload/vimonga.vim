
function! vimonga#start() abort
    let host = shellescape(vimonga#config#get('default_host'))
    let port = vimonga#config#get('default_port')
    let cmd = join(['vimonga', '-h', host, '-p', port], ' ')

    let db_names = systemlist(cmd)

    tabnew
    setlocal buftype=nofile
    setlocal nobuflisted
    setlocal noswapfile

    call setline(1, db_names)
endfunction
