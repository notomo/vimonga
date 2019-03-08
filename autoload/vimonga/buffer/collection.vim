
function! vimonga#buffer#collection#drop(open_cmd) abort
    call vimonga#buffer#ensure_collections()

    if input('Drop? YES/n: ') !=# 'YES'
        redraw
        echomsg 'Canceled'
        return
    endif

    let database_name = vimonga#param#database_name()
    let [result, err] = vimonga#repo#collection#drop_by_number(database_name)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    let [result, err] = vimonga#repo#collection#list(database_name)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    call vimonga#buffer#open_collections(result, a:open_cmd)
endfunction

function! vimonga#buffer#collection#list(open_cmd) abort
    call vimonga#buffer#ensure_databases()

    let [result, err] = vimonga#repo#collection#list_by_number()
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    call vimonga#buffer#open_collections(result, a:open_cmd)
endfunction

function! vimonga#buffer#collection#open_from_child(open_cmd) abort
    call vimonga#buffer#ensure_collection_children()

    let database_name = vimonga#param#database_name()
    let [result, err] = vimonga#repo#collection#list(database_name)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    call vimonga#buffer#open_collections(result, a:open_cmd)
endfunction
