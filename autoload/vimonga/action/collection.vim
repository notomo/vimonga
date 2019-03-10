
function! vimonga#action#collection#drop(open_cmd) abort
    let params = vimonga#buffer#ensure_collections()
    let collection_name = params['collection_name']

    if input('Drop ' . collection_name . '? YES/n: ') !=# 'YES'
        redraw | echomsg 'Canceled'
        return
    endif

    let database_name = params['database_name']
    let collection_name = params['collection_name']
    let [result, err] = vimonga#repo#collection#drop(database_name, collection_name)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    let [result, err] = vimonga#repo#collection#list(database_name)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    call vimonga#buffer#open_collections(result, a:open_cmd)
endfunction

function! vimonga#action#collection#list(open_cmd) abort
    let params = vimonga#buffer#ensure_database_name()

    let database_name = params['database_name']
    let [result, err] = vimonga#repo#collection#list(database_name)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    call vimonga#buffer#open_collections(result, a:open_cmd)
endfunction
