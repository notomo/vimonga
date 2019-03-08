
function! vimonga#buffer#documents#projection#reset_all(open_cmd) abort
    let options = vimonga#repo#document#options({'projection': {}})

    let database_name = vimonga#param#database_name()
    let collection_name = vimonga#param#collection_name()
    let [result, err] = vimonga#repo#document#find(database_name, collection_name, options)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    call vimonga#buffer#open_documents(result, a:open_cmd, options)
endfunction

function! vimonga#buffer#documents#projection#hide(open_cmd) abort
    let options = vimonga#repo#document#options({})

    let field_name = vimonga#json#field_name(line('.'))
    if empty(field_name)
        return
    endif
    let options['projection'][field_name] = 0

    let database_name = vimonga#param#database_name()
    let collection_name = vimonga#param#collection_name()
    let [result, err] = vimonga#repo#document#find(database_name, collection_name, options)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    call vimonga#buffer#open_documents(result, a:open_cmd, options)
endfunction
