
function! vimonga#repo#index#list_by_number(database_name) abort
    let pid = vimonga#request#pid_option()
    let database = vimonga#request#option('database', a:database_name)
    let number = vimonga#request#number_option()
    return vimonga#request#json(['index', pid, number, database, 'list'])
endfunction
