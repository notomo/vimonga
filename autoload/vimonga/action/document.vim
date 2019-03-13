
function! vimonga#action#document#update() abort
    let params = vimonga#buffer#document#ensure()

    let database_name = params['database_name']
    let collection_name = params['collection_name']
    let document_id = params['document_id']
    let document = join(getbufline('%', 1, '$'), '')

    let [_, err] = vimonga#repo#document#update(database_name, collection_name, document_id, document)
    if !empty(err)
        echohl ErrorMsg | echo join(err, "\n") | echohl None | return
    endif
    set nomodified
endfunction

function! vimonga#action#document#open(open_cmd) abort
    let params = vimonga#buffer#document#ensure_id()
    let database_name = params['database_name']
    let collection_name = params['collection_name']
    let document_id = params['document_id']
    let funcs = [{ -> vimonga#repo#document#find_by_id(database_name, collection_name, document_id)}]
    call vimonga#buffer#document#open(funcs, a:open_cmd)
endfunction
