
function! vimonga#buffer#documents#query#reset_all(open_cmd) abort
    call vimonga#buffer#ensure_documents()

    let options = vimonga#repo#document#options({'query': {}})

    let database_name = vimonga#param#database_name()
    let collection_name = vimonga#param#collection_name()
    let [result, err] = vimonga#repo#document#find(database_name, collection_name, options)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    call vimonga#buffer#open_documents(result, a:open_cmd, options)
endfunction

function! vimonga#buffer#documents#query#add(open_cmd) abort
    call vimonga#buffer#ensure_documents()

    let [key, value] = vimonga#json#key_value(line('.'))
    if empty(key)
        return
    endif

    let options = vimonga#repo#document#options({})
    let options['query'][key] = value

    let database_name = vimonga#param#database_name()
    let collection_name = vimonga#param#collection_name()
    let [result, err] = vimonga#repo#document#find(database_name, collection_name, options)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    call vimonga#buffer#open_documents(result, a:open_cmd, options)
endfunction
