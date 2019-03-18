
function! vimonga#repo#index#list(collection) abort
    let db = vimonga#repo#impl#option('database', a:collection.database_name)
    let coll = vimonga#repo#impl#option('collection', a:collection.name)
    return vimonga#repo#impl#execute(['index', db, coll, 'list'])
endfunction
