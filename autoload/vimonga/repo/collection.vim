
function! vimonga#repo#collection#list(database) abort
    let db = vimonga#repo#impl#option('database', a:database.name)
    return vimonga#repo#impl#execute(['collection', db, 'list'], a:database.connection())
endfunction

function! vimonga#repo#collection#drop(collections) abort
    let conn = a:collections[0].database().connection()
    let db = vimonga#repo#impl#option('database', a:collections[0].database_name)
    let colls = map(copy(a:collections), {_, coll -> vimonga#repo#impl#option('collections', coll.name)})
    return vimonga#repo#impl#execute(extend(['collection', db, 'drop'], colls), conn)
endfunction

function! vimonga#repo#collection#create(collections) abort
    let conn = a:collections[0].database().connection()
    let db = vimonga#repo#impl#option('database', a:collections[0].database_name)
    let colls = map(copy(a:collections), {_, coll -> vimonga#repo#impl#option('collections', coll.name)})
    return vimonga#repo#impl#execute(extend(['collection', db, 'create'], colls), conn)
endfunction
