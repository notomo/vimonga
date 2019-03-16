
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
    setlocal nomodified
endfunction

function! vimonga#action#document#open(open_cmd) abort
    let params = vimonga#buffer#document#ensure_id()
    let database_name = params['database_name']
    let collection_name = params['collection_name']
    let document_id = params['document_id']
    let funcs = [{ -> vimonga#repo#document#find_by_id(database_name, collection_name, document_id)}]
    call vimonga#buffer#document#open(funcs, a:open_cmd)
endfunction

function! vimonga#action#document#new(open_cmd) abort
    let params = vimonga#buffer#documents#ensure()
    call vimonga#buffer#document#new(bufname('%') . '/new', a:open_cmd)
endfunction

function! vimonga#action#document#insert() abort
    let params = vimonga#buffer#document#ensure_new()

    let database_name = params['database_name']
    let collection_name = params['collection_name']
    let document = join(getbufline('%', 1, '$'), '')

    let [result, err] = vimonga#repo#document#insert(database_name, collection_name, document)
    if !empty(err)
        echohl ErrorMsg | echo join(err, "\n") | echohl None | return
    endif

    let body = result['body']
    if empty(body)
        return
    endif

    let database_name = result['database_name']
    let collection_name = result['collection_name']
    let document_id = body[0]
    let funcs = [{ -> vimonga#repo#document#find_by_id(database_name, collection_name, document_id)}]
    call vimonga#buffer#document#open(funcs, 'edit')
endfunction

function! vimonga#action#document#delete() abort
    let params = vimonga#buffer#document#ensure()
    let database_name = params['database_name']
    let collection_name = params['collection_name']
    let document_id = params['document_id']

    if input('Delete ' . document_id . '? y/n: ') !=# 'y'
        redraw | echomsg 'Canceled' | return
    endif

    let [_, err] = vimonga#repo#document#delete(database_name, collection_name, document_id)
    if !empty(err)
        echohl ErrorMsg | echo join(err, "\n") | echohl None | return
    endif

    autocmd! vimonga_doc * <buffer>
    setlocal nomodifiable
    setlocal buftype=nofile
    setlocal nomodified
    let &filetype = vimonga#buffer#document#filetype_delete()
endfunction
