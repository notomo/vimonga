
function! vimonga#action#documents#find(params, options) abort
    let options = vimonga#buffer#documents#options(a:options)
    return vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#collections#model(a:params) })
        \.map_ok({ collection -> vimonga#buffer#documents#open(collection, a:params.open_cmd, options) })
        \.map_extend_ok({ buf -> vimonga#repo#document#find(buf.collection, options) })
        \.map_ok({ buf, result -> vimonga#buffer#documents#content(buf, result, options) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction

function! vimonga#action#documents#next(params) abort
    let options = vimonga#buffer#documents#options()
    if options['is_last']
        return
    endif

    let options['offset'] += options['limit']
    return vimonga#action#documents#find(a:params, options)
endfunction

function! vimonga#action#documents#prev(params) abort
    let options = vimonga#buffer#documents#options()
    if options['offset'] == 0
        return
    endif

    let options['offset'] -= options['limit']
    if options['offset'] < 0
        let options['offset'] = 0
    endif
    return vimonga#action#documents#find(a:params, options)
endfunction

function! vimonga#action#documents#first(params) abort
    let options = vimonga#buffer#documents#options({'offset': 0})
    return vimonga#action#documents#find(a:params, options)
endfunction

function! vimonga#action#documents#last(params) abort
    let options = vimonga#buffer#documents#options()
    let options['offset'] = float2nr(options['count'] / options['limit']) * options['limit']
    return vimonga#action#documents#find(a:params, options)
endfunction
