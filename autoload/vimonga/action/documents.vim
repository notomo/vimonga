
function! vimonga#action#documents#find(params, options) abort
    let collection = vimonga#buffer#collections#model(a:params)
    let options = vimonga#repo#document#options(a:options)
    let funcs = [{ -> vimonga#repo#document#find(collection, options)}]
    call vimonga#buffer#documents#open(funcs, a:params.open_cmd, options)
endfunction

function! vimonga#action#documents#move_page(params, direction) abort
    let collection = vimonga#buffer#collections#model(a:params)

    let options = vimonga#repo#document#options()
    if (options['is_last'] && a:direction > 0) || (options['offset'] == 0 && a:direction < 0)
        return
    endif

    let options['offset'] += options['limit'] * a:direction
    if options['offset'] < 0
        let options['offset'] = 0
    endif

    let funcs = [{ -> vimonga#repo#document#find(collection, options)}]
    call vimonga#buffer#documents#open(funcs, a:params.open_cmd, options)
endfunction

function! vimonga#action#documents#first(params) abort
    let collection = vimonga#buffer#collections#model(a:params)

    let options = vimonga#repo#document#options()
    let options['offset'] = 0

    let funcs = [{ -> vimonga#repo#document#find(collection, options)}]
    call vimonga#buffer#documents#open(funcs, a:params.open_cmd, options)
endfunction

function! vimonga#action#documents#last(params) abort
    let collection = vimonga#buffer#collections#model(a:params)

    let options = vimonga#repo#document#options()
    let options['offset'] = float2nr(options['count'] / options['limit']) * options['limit']

    let funcs = [{ -> vimonga#repo#document#find(collection, options)}]
    call vimonga#buffer#documents#open(funcs, a:params.open_cmd, options)
endfunction
