
function! vimonga#repo#index#list(database_name, collection_name) abort
    let database = vimonga#request#option('database', a:database_name)
    let collection = vimonga#request#option('collection', a:collection_name)
    return vimonga#request#json(['index', database, collection, 'list'])
endfunction
