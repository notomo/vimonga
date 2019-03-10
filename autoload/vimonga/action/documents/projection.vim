
function! vimonga#action#documents#projection#reset_all(open_cmd) abort
    let params = vimonga#buffer#ensure_documents()

    let options = vimonga#repo#document#options({'projection': {}})

    let database_name = params['database_name']
    let collection_name = params['collection_name']
    let funcs = [{ -> vimonga#repo#document#find(database_name, collection_name, options)}]
    call vimonga#buffer#open_documents(funcs, a:open_cmd, options)
endfunction

function! vimonga#action#documents#projection#hide(open_cmd) abort
    let params = vimonga#buffer#ensure_documents()

    let field_name = vimonga#json#field_name(line('.'))
    if empty(field_name)
        return
    endif
    let options = vimonga#repo#document#options()
    let options['projection'][field_name] = 0

    let database_name = params['database_name']
    let collection_name = params['collection_name']
    let funcs = [{ -> vimonga#repo#document#find(database_name, collection_name, options)}]
    call vimonga#buffer#open_documents(funcs, a:open_cmd, options)
endfunction
