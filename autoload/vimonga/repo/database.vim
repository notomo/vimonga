
function! vimonga#repo#database#list() abort
    return vimonga#request#json(['database', 'list'])
endfunction

function! vimonga#repo#database#drop(database_name) abort
    let database = vimonga#request#option('database', a:database_name)
    return vimonga#request#json(['database', 'drop', database])
endfunction
