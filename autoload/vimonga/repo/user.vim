
function! vimonga#repo#user#list(database) abort
    let db = vimonga#repo#impl#option('database', a:database.name)
    return vimonga#repo#impl#execute(['database', 'users', db])
endfunction
