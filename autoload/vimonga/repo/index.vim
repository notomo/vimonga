
function! vimonga#repo#index#list(collection) abort
    let conn = a:collection.database().connection()
    let db = vimonga#repo#impl#option('database', a:collection.database_name)
    let coll = vimonga#repo#impl#option('collection', a:collection.name)
    return vimonga#repo#impl#execute(['index', db, coll, 'list'], conn)
endfunction

function! vimonga#repo#index#create(collection, content) abort
    let conn = a:collection.database().connection()
    let db = vimonga#repo#impl#option('database', a:collection.database_name)
    let coll = vimonga#repo#impl#option('collection', a:collection.name)
    let keys = vimonga#repo#impl#option('keys', a:content)
    return vimonga#repo#impl#execute(['index', db, coll, 'create', keys], conn)
endfunction

function! vimonga#repo#index#drop(index) abort
    let conn = a:index.collection().database().connection()
    let db = vimonga#repo#impl#option('database', a:index.database_name)
    let coll = vimonga#repo#impl#option('collection', a:index.collection_name)
    let name = vimonga#repo#impl#option('name', a:index.name)
    return vimonga#repo#impl#execute(['index', db, coll, 'drop', name], conn)
endfunction
