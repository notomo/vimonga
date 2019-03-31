
function! vimonga#repo#database#list(conn) abort
    return vimonga#repo#impl#execute(a:conn, ['database', 'list'])
endfunction

function! vimonga#repo#database#drop(database) abort
    let db = vimonga#repo#impl#option('database', a:database.name)
    return vimonga#repo#impl#execute(a:database.connection(), ['database', 'drop', db])
endfunction
