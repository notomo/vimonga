
function! vimonga#action#index#list(open_cmd) abort
    let params = vimonga#buffer#ensure_collections()
    let database_name = params['database_name']
    let collection_name = params['collection_name']

    let funcs = [{ -> vimonga#repo#index#list(database_name, collection_name)}]
    call vimonga#buffer#open_indexes(funcs, a:open_cmd)
endfunction
