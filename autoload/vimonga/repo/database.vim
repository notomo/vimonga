
function! vimonga#repo#database#list() abort
    return vimonga#repo#impl#execute(['database', 'list'])
endfunction

function! vimonga#repo#database#users(database_name) abort
    let database = vimonga#repo#impl#option('database', a:database_name)
    return vimonga#repo#impl#execute(['database', 'users', database])
endfunction

function! vimonga#repo#database#drop(database_name) abort
    let database = vimonga#repo#impl#option('database', a:database_name)
    return vimonga#repo#impl#execute(['database', 'drop', database])
endfunction
