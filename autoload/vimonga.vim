
function! vimonga#databases() abort
    let db_names = s:execute([])

    call s:buffer(db_names)
endfunction

function! vimonga#collections(database_name) abort
    let name = shellescape(a:database_name)
    let collection_names = s:execute(['-d', name, '-m', 'collection'])

    call s:buffer(collection_names)
endfunction

function! vimonga#documents(database_name, collection_name, ...) abort
    let database_name = shellescape(a:database_name)
    let collection_name = shellescape(a:collection_name)
    let args = ['-d', database_name, '-c', collection_name, '-m', 'document']
    if len(a:000) >= 1 && len(a:000[0]) > 0
        let query = shellescape(a:000[0])
        call extend(args, ['-q', query])
    endif
    if len(a:000) >= 2  && len(a:000[1]) > 0
        let projection = shellescape(a:000[1])
        call extend(args, ['-r', projection])
    endif

    let documents = s:execute(args)

    call s:buffer(documents)
endfunction

function! s:buffer(contents) abort
    tabnew

    setlocal buftype=nofile
    setlocal nobuflisted
    setlocal noswapfile

    call setline(1, a:contents)
endfunction

function! s:execute(args) abort
    let host = shellescape(vimonga#config#get('default_host'))
    let port = vimonga#config#get('default_port')
    let default_args = ['RUST_BACKTRACE=1', 'vimonga', '-h', host, '-p', port]

    let cmd = join(default_args + a:args, ' ')
    return systemlist(cmd)
endfunction
