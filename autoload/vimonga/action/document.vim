
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
