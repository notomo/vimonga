
function! vimonga#databases() abort
    call vimonga#buffer#database#open_list()
endfunction

function! vimonga#collections(database_name) abort
    call vimonga#buffer#collection#open_list(a:database_name)
endfunction

function! vimonga#documents(database_name, collection_name, ...) abort
    call call('vimonga#buffer#document#find', [a:database_name, a:collection_name] + a:000)
endfunction
