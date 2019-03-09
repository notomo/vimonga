
function! vimonga#repo#index#list(database_name, collection_name) abort
    let database = vimonga#repo#impl#option('database', a:database_name)
    let collection = vimonga#repo#impl#option('collection', a:collection_name)
    return vimonga#repo#impl#execute(['index', database, collection, 'list'])
endfunction
