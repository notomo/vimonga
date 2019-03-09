
function! vimonga#action#index#list(open_cmd) abort
    let params = vimonga#buffer#ensure_collections()

    let database_name = params['database_name']
    let collection_name = params['collection_name']
    let [result, err] = vimonga#repo#index#list(database_name, collection_name)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    call vimonga#buffer#open_indexes(result, a:open_cmd)
endfunction
