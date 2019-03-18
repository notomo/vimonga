
function! vimonga#action#document#update() abort
    let document = vimonga#buffer#document#ensure()
    let content = join(getbufline('%', 1, '$'), '')

    let [_, err] = vimonga#repo#document#update(document, content)
    if !empty(err)
        echohl ErrorMsg | echo join(err, "\n") | echohl None | return
    endif
    setlocal nomodified
endfunction

function! vimonga#action#document#open(open_cmd) abort
    let document = vimonga#buffer#document#ensure_id()
    let funcs = [{ -> vimonga#repo#document#find_by_id(document)}]
    call vimonga#buffer#document#open(funcs, a:open_cmd)
endfunction

function! vimonga#action#document#new(open_cmd) abort
    call vimonga#buffer#documents#ensure()
    call vimonga#buffer#document#new(bufname('%') . '/new', a:open_cmd)
endfunction

function! vimonga#action#document#insert() abort
    let draft_document = vimonga#buffer#document#ensure_new()
    let content = join(getbufline('%', 1, '$'), '')

    let [result, err] = vimonga#repo#document#insert(draft_document, content)
    if !empty(err)
        echohl ErrorMsg | echo join(err, "\n") | echohl None | return
    endif

    let body = result['body']
    if empty(body)
        return
    endif

    let id = body[0]
    let funcs = [{ -> vimonga#repo#document#find_by_id(draft_document.document(id))}]
    call vimonga#buffer#document#open(funcs, 'edit')
endfunction

function! vimonga#action#document#delete() abort
    let document = vimonga#buffer#document#ensure()
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
