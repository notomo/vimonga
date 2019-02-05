
function! vimonga#databases() abort
    let db_names = s:execute([])

    call s:buffer(db_names)
endfunction

function! vimonga#collections(database_name) abort
    let name = shellescape(a:database_name)
    let collection_names = s:execute(['-d', name, '-m', 'collection'])

    call s:buffer(collection_names)
endfunction

function! vimonga#documents(database_name, collection_name) abort
    let database_name = shellescape(a:database_name)
    let collection_name = shellescape(a:collection_name)
    let documents = s:execute(['-d', database_name, '-c', collection_name, '-m', 'document'])

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
    let default_args = ['vimonga', '-h', host, '-p', port]

    let cmd = join(default_args + a:args, ' ')
    return systemlist(cmd)
endfunction
