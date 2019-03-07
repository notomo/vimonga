
function! vimonga#repo#collection#list(database_name) abort
    let pid = vimonga#request#pid_option()
    let database = vimonga#request#option('database', a:database_name)
    return vimonga#request#json(['collection', pid, database, 'list'])
endfunction

function! vimonga#repo#collection#list_by_number() abort
    let pid = vimonga#request#pid_option()
    let number = vimonga#request#number_option()
    return vimonga#request#json(['collection', pid, number, 'list'])
endfunction

function! vimonga#repo#collection#drop_by_number(database_name) abort
    let pid = vimonga#request#pid_option()
    let database = vimonga#request#option('database', a:database_name)
    let number = vimonga#request#number_option()
    return vimonga#request#json(['collection', pid, database, 'drop', number])
endfunction
