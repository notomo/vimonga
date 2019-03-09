
function! vimonga#repo#collection#list(database_name) abort
    let database = vimonga#repo#impl#option('database', a:database_name)
    return vimonga#repo#impl#execute(['collection', database, 'list'])
endfunction

function! vimonga#repo#collection#drop(database_name, collection_name) abort
    let database = vimonga#repo#impl#option('database', a:database_name)
    let collection = vimonga#repo#impl#option('collection', a:collection_name)
    return vimonga#repo#impl#execute(['collection', database, 'drop', collection])
endfunction
