
let s:filetype = 'vimonga-indexes'

function! vimonga#buffer#indexes#open(collection, open_cmd) abort
    let path = vimonga#buffer#indexes#path(a:collection)
    let [buf, cursor] =  vimonga#buffer#impl#buffer(s:filetype, path, a:open_cmd)

    augroup vimonga_indexes
        autocmd!
        autocmd BufReadCmd <buffer> Vimonga index.list
    augroup END

    return vimonga#job#ok({'id': buf, 'collection': a:collection, 'cursor': cursor})
endfunction

function! vimonga#buffer#indexes#path(collection) abort
    let dbs = vimonga#buffer#collections#path(a:collection.database())
    return printf('%s/%s/indexes', dbs, a:collection.name)
endfunction
