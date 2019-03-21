
function! vimonga#repo#database#list() abort
    return vimonga#repo#impl#execute(['database', 'list'])
endfunction

function! vimonga#repo#database#drop(database) abort
    let db = vimonga#repo#impl#option('database', a:database.name)
    return vimonga#repo#impl#execute(['database', 'drop', db])
endfunction
