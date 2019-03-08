
function! vimonga#param#database_name() abort
    return matchstr(bufname('%'), '\vvimonga:\/\/.*\/dbs\/\zs[^/]*\ze')
endfunction

function! vimonga#param#collection_name() abort
    return matchstr(bufname('%'), '\vvimonga:\/\/.*\/dbs\/[^/]*\/colls\/\zs[^/]*\ze')
endfunction
