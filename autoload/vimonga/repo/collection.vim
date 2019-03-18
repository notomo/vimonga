
function! vimonga#repo#collection#list(database) abort
    let db = vimonga#repo#impl#option('database', a:database.name)
    return vimonga#repo#impl#execute(['collection', db, 'list'])
endfunction

function! vimonga#repo#collection#drop(collection) abort
    let db = vimonga#repo#impl#option('database', a:collection.database_name)
    let coll = vimonga#repo#impl#option('collection', a:collection.name)
    return vimonga#repo#impl#execute(['collection', db, 'drop', coll])
endfunction

function! vimonga#repo#collection#create(collection) abort
    let db = vimonga#repo#impl#option('database', a:collection.database_name)
    let coll = vimonga#repo#impl#option('collection', a:collection.name)
    return vimonga#repo#impl#execute(['collection', db, 'create', coll])
endfunction
