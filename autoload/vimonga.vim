
function! vimonga#databases() abort
    let db_names = s:execute(['database'])

    call s:buffer(db_names)
endfunction

function! vimonga#collections(database_name) abort
    let collection_names = s:execute(['collection', s:option('database', a:database_name)])

    call s:buffer(collection_names)
endfunction

function! vimonga#documents(database_name, collection_name, ...) abort
    let database = s:option('database', a:database_name)
    let collection = s:option('collection', a:collection_name)
    let args = ['document', database, collection]
    if len(a:000) >= 1 && len(a:000[0]) > 0
        call extend(args, [s:option('query', a:000[0])])
    endif
    if len(a:000) >= 2  && len(a:000[1]) > 0
        call extend(args, [s:option('projection', a:000[1])])
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
    let host = vimonga#config#get('default_host')
    let port = vimonga#config#get('default_port')
    let default_args = ['RUST_BACKTRACE=1', 'monga', s:option('host', host), s:option('port', port)]

    let cmd = join(default_args + a:args, ' ')
    return systemlist(cmd)
endfunction

function! s:option(key, value) abort
    return '--' . a:key . '=' . shellescape(a:value)
endfunction
