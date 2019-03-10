
function! vimonga#action#documents#sort#reset_all(open_cmd) abort
    let params = vimonga#buffer#ensure_documents()

    let options = vimonga#repo#document#options({'sort': {}})

    let database_name = params['database_name']
    let collection_name = params['collection_name']
    let funcs = [{ -> vimonga#repo#document#find(database_name, collection_name, options)}]
    call vimonga#buffer#open_documents(funcs, a:open_cmd, options)
endfunction

function! vimonga#action#documents#sort#toggle(open_cmd) abort
    let params = vimonga#buffer#ensure_documents()

    let field_name = vimonga#json#field_name(line('.'))
    if empty(field_name)
        return
    endif

    let options = vimonga#repo#document#options()
    if !has_key(options['sort'], field_name)
        let options['sort'][field_name] = -1
    else
        let options['sort'][field_name] = options['sort'][field_name] * -1
    endif
    let options['offset'] = 0

    let database_name = params['database_name']
    let collection_name = params['collection_name']
    let funcs = [{ -> vimonga#repo#document#find(database_name, collection_name, options)}]
    call vimonga#buffer#open_documents(funcs, a:open_cmd, options)
endfunction

function! vimonga#action#documents#sort#do(direction, open_cmd) abort
    let params = vimonga#buffer#ensure_documents()

    let field_name = vimonga#json#field_name(line('.'))
    if empty(field_name)
        return
    endif

    let options = vimonga#repo#document#options()
    if a:direction == 0 && !has_key(options['sort'], field_name)
        return
    elseif a:direction == 0
        unlet options['sort'][field_name]
    else
        let options['sort'][field_name] = a:direction
    endif
    let options['offset'] = 0

    let database_name = params['database_name']
    let collection_name = params['collection_name']
    let funcs = [{ -> vimonga#repo#document#find(database_name, collection_name, options)}]
    call vimonga#buffer#open_documents(funcs, a:open_cmd, options)
endfunction
