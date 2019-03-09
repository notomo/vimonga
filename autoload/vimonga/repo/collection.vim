
function! vimonga#repo#collection#list(database_name) abort
    let database = vimonga#request#option('database', a:database_name)
    return vimonga#request#json(['collection', database, 'list'])
endfunction

function! vimonga#repo#collection#drop(database_name, collection_name) abort
    let database = vimonga#request#option('database', a:database_name)
    let collection = vimonga#request#option('collection', a:collection_name)
    return vimonga#request#json(['collection', database, 'drop', collection])
endfunction
