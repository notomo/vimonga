
function! vimonga#action#document#update(params) abort
    let document = vimonga#buffer#document#model(a:params)
    let content = join(getbufline('%', 1, '$'), '')

    let [_, err] = vimonga#repo#document#update(document, content)
    if !empty(err)
        echohl ErrorMsg | echo join(err, "\n") | echohl None | return
    endif
    setlocal nomodified
endfunction

function! vimonga#action#document#open(params) abort
    let document = vimonga#buffer#document#model(a:params)
    let funcs = [{ -> vimonga#repo#document#find_by_id(document)}]
    call vimonga#buffer#document#open(funcs, a:params.open_cmd)
endfunction

function! vimonga#action#document#new(params) abort
    call vimonga#buffer#documents#ensure()

    let document = vimonga#buffer#document#model(a:params)
    call vimonga#buffer#document#new(bufname('%') . '/new', a:params.open_cmd)
endfunction

function! vimonga#action#document#insert(params) abort
    call vimonga#buffer#document#ensure_new()

    let collection = vimonga#buffer#collections#model(a:params)
    let content = join(getbufline('%', 1, '$'), '')

    let [result, err] = vimonga#repo#document#insert(collection, content)
    if !empty(err)
        echohl ErrorMsg | echo join(err, "\n") | echohl None | return
    endif

    let body = result['body']
    if empty(body)
        return
    endif

    let id = body[0]
    let funcs = [{ -> vimonga#repo#document#find_by_id(collection.document(id))}]
    call vimonga#buffer#document#open(funcs, 'edit')
endfunction

function! vimonga#action#document#delete(params) abort
    let document = vimonga#buffer#document#model(a:params)
    if input('Delete ' . document.id . '? y/n: ') !=# 'y'
        redraw | echomsg 'Canceled' | return
    endif

    let [_, err] = vimonga#repo#document#delete(document)
    if !empty(err)
        echohl ErrorMsg | echo join(err, "\n") | echohl None | return
    endif

    autocmd! vimonga_doc * <buffer>
    setlocal nomodifiable
    setlocal buftype=nofile
    setlocal nomodified
    let &filetype = vimonga#buffer#document#filetype_delete()
endfunction
