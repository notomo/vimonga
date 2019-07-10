
function! vimonga#repo#database#list(conn) abort
    return vimonga#repo#impl#execute(['database', 'list'], a:conn)
endfunction

function! vimonga#repo#database#drop(databases) abort
    let dbs = map(copy(a:databases), {_, db -> vimonga#repo#impl#option('databases', db.name)})
    return vimonga#repo#impl#execute(extend(['database', 'drop'], dbs), a:databases[0].connection())
endfunction
