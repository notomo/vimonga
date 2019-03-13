
function! vimonga#action#documents#find(open_cmd, options) abort
    let params = vimonga#buffer#collections#ensure_name()

    let database_name = params['database_name']
    let collection_name = params['collection_name']
    let options = vimonga#repo#document#options(a:options)

    let funcs = [{ -> vimonga#repo#document#find(database_name, collection_name, options)}]
    call vimonga#buffer#documents#open(funcs, a:open_cmd, options)
endfunction

function! vimonga#action#documents#move_page(open_cmd, direction) abort
    let params = vimonga#buffer#documents#ensure()

    let options = vimonga#repo#document#options()
    if (options['is_last'] && a:direction > 0) || (options['offset'] == 0 && a:direction < 0)
        return
    endif

    let database_name = params['database_name']
    let collection_name = params['collection_name']
    let options['offset'] += options['limit'] * a:direction
    if options['offset'] < 0
        let options['offset'] = 0
    endif

    let funcs = [{ -> vimonga#repo#document#find(database_name, collection_name, options)}]
    call vimonga#buffer#documents#open(funcs, a:open_cmd, options)
endfunction

function! vimonga#action#documents#first(open_cmd) abort
    let params = vimonga#buffer#documents#ensure()

    let database_name = params['database_name']
    let collection_name = params['collection_name']
    let options = vimonga#repo#document#options()
    let options['offset'] = 0

    let funcs = [{ -> vimonga#repo#document#find(database_name, collection_name, options)}]
    call vimonga#buffer#documents#open(funcs, a:open_cmd, options)
endfunction

function! vimonga#action#documents#last(open_cmd) abort
    let params = vimonga#buffer#documents#ensure()

    let database_name = params['database_name']
    let collection_name = params['collection_name']
    let options = vimonga#repo#document#options()
    let options['offset'] = float2nr(options['count'] / options['limit']) * options['limit']

    let funcs = [{ -> vimonga#repo#document#find(database_name, collection_name, options)}]
    call vimonga#buffer#documents#open(funcs, a:open_cmd, options)
endfunction