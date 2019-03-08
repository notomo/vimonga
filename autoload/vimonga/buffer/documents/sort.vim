
function! vimonga#buffer#documents#sort#reset_all(open_cmd) abort
    call vimonga#buffer#ensure_documents()

    let options = vimonga#repo#document#options({'sort': {}})

    let database_name = vimonga#param#database_name()
    let collection_name = vimonga#param#collection_name()
    let [result, err] = vimonga#repo#document#find(database_name, collection_name, options)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    call vimonga#buffer#open_documents(result, a:open_cmd, options)
endfunction

function! vimonga#buffer#documents#sort#toggle(open_cmd) abort
    call vimonga#buffer#ensure_documents()

    let field_name = vimonga#json#field_name(line('.'))
    if empty(field_name)
        return
    endif

    let options = vimonga#repo#document#options({})
    if !has_key(options['sort'], field_name)
        let options['sort'][field_name] = -1
    else
        let options['sort'][field_name] = options['sort'][field_name] * -1
    endif
    let options['offset'] = 0

    let database_name = vimonga#param#database_name()
    let collection_name = vimonga#param#collection_name()
    let [result, err] = vimonga#repo#document#find(database_name, collection_name, options)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    call vimonga#buffer#open_documents(result, a:open_cmd, options)
endfunction

function! vimonga#buffer#documents#sort#do(direction, open_cmd) abort
    call vimonga#buffer#ensure_documents()

    let field_name = vimonga#json#field_name(line('.'))
    if empty(field_name)
        return
    endif

    let options = vimonga#repo#document#options({})
    if a:direction == 0 && !has_key(options['sort'], field_name)
        return
    elseif a:direction == 0
        unlet options['sort'][field_name]
    else
        let options['sort'][field_name] = a:direction
    endif
    let options['offset'] = 0

    let database_name = vimonga#param#database_name()
    let collection_name = vimonga#param#collection_name()
    let [result, err] = vimonga#repo#document#find(database_name, collection_name, options)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    call vimonga#buffer#open_documents(result, a:open_cmd, options)
endfunction
