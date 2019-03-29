
function! vimonga#repo#user#list(database) abort
    let db = vimonga#repo#impl#option('database', a:database.name)
    return vimonga#repo#impl#execute(['user', db, 'list'])
endfunction

function! vimonga#repo#user#create(database, content) abort
    let db = vimonga#repo#impl#option('database', a:database.name)
    let info = vimonga#repo#impl#option('info', a:content)
    return vimonga#repo#impl#execute(['user', db, 'create', info])
endfunction

function! vimonga#repo#user#drop(user) abort
    let db = vimonga#repo#impl#option('database', a:user.database_name)
    let name = vimonga#repo#impl#option('name', a:user.name)
    return vimonga#repo#impl#execute(['user', db, 'drop', name])
endfunction
