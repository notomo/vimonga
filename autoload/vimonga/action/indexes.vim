
function! vimonga#action#indexes#list(open_cmd) abort
    let params = vimonga#buffer#collections#ensure()
    let database_name = params['database_name']
    let collection_name = params['collection_name']

    let funcs = [{ -> vimonga#repo#index#list(database_name, collection_name)}]
    call vimonga#buffer#indexes#open(funcs, a:open_cmd)
endfunction
