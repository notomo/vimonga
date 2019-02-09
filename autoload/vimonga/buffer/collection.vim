
function! vimonga#buffer#collection#open_list(database_name) abort
    let database = vimonga#request#option('database', a:database_name)
    let collection_names = vimonga#request#execute(['collection', database])

    call vimonga#buffer#base#open(collection_names, 'vimonga-coll')
endfunction
