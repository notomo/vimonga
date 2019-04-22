
function! vimonga#repo#database#list(conn) abort
    return vimonga#repo#impl#execute(['database', 'list'], a:conn)
endfunction

function! vimonga#repo#database#drop(database) abort
    let db = vimonga#repo#impl#option('database', a:database.name)
    return vimonga#repo#impl#execute(['database', 'drop', db], a:database.connection())
endfunction
