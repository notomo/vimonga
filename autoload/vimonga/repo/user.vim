
function! vimonga#repo#user#list(database) abort
    let db = vimonga#repo#impl#option('database', a:database.name)
    return vimonga#repo#impl#execute(['user', db, 'list'])
endfunction

function! vimonga#repo#user#create(database, content) abort
    let db = vimonga#repo#impl#option('database', a:database.name)
    let info = vimonga#repo#impl#option('info', a:content)
    return vimonga#repo#impl#execute(['user', db, 'create', info])
endfunction
