
function! vimonga#buffer#document#find(open_cmd) abort
    call vimonga#buffer#ensure_collections()

    let options = vimonga#repo#document#options({})
    let database_name = vimonga#param#database_name()
    let [result, err] = vimonga#repo#document#find_by_number(database_name, options)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    call vimonga#buffer#open_documents(result, a:open_cmd, options)
endfunction

function! vimonga#buffer#document#move_page(open_cmd, direction) abort
    call vimonga#buffer#ensure_documents()

    let options = vimonga#repo#document#options({})
    if (options['is_last'] && a:direction > 0) || (options['offset'] == 0 && a:direction < 0)
        return
    endif

    let options['offset'] += options['limit'] * a:direction
    if options['offset'] < 0
        let options['offset'] = 0
    endif

    let database_name = vimonga#param#database_name()
    let collection_name = vimonga#param#collection_name()
    let [result, err] = vimonga#repo#document#find(database_name, collection_name, options)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    call vimonga#buffer#open_documents(result, a:open_cmd, options)
endfunction

function! vimonga#buffer#document#first(open_cmd) abort
    call vimonga#buffer#ensure_documents()

    let options = vimonga#repo#document#options({})
    let options['offset'] = 0

    let database_name = vimonga#param#database_name()
    let collection_name = vimonga#param#collection_name()
    let [result, err] = vimonga#repo#document#find(database_name, collection_name, options)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    call vimonga#buffer#open_documents(result, a:open_cmd, options)
endfunction

function! vimonga#buffer#document#last(open_cmd) abort
    call vimonga#buffer#ensure_documents()

    let options = vimonga#repo#document#options({})
    let options['offset'] = float2nr(options['count'] / options['limit']) * options['limit']

    let database_name = vimonga#param#database_name()
    let collection_name = vimonga#param#collection_name()
    let [result, err] = vimonga#repo#document#find(database_name, collection_name, options)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    call vimonga#buffer#open_documents(result, a:open_cmd, options)
endfunction
