
function! vimonga#action#documents#find(params, options) abort
    let options = vimonga#repo#document#options(a:options)
    call vimonga#job#new()
        \.map_ok({ _ -> vimonga#buffer#collections#model(a:params) })
        \.map_ok({ collection -> vimonga#buffer#documents#open(collection, a:params.open_cmd, options) })
        \.map_extend_ok({ buf -> vimonga#repo#document#find(buf.collection, options) })
        \.map_ok({ buf, result -> vimonga#buffer#documents#content(buf.id, result, options) })
        \.map_err({ err -> vimonga#message#error(err) })
        \.execute()
endfunction

function! vimonga#action#documents#move_page(params, direction) abort
    let options = vimonga#repo#document#options()
    if (options['is_last'] && a:direction > 0) || (options['offset'] == 0 && a:direction < 0)
        return
    endif
    let options['offset'] += options['limit'] * a:direction
    if options['offset'] < 0
        let options['offset'] = 0
    endif

    call vimonga#action#documents#find(a:params, options)
endfunction

function! vimonga#action#documents#first(params) abort
    let options = vimonga#repo#document#options({'offset': 0})
    call vimonga#action#documents#find(a:params, options)
endfunction

function! vimonga#action#documents#last(params) abort
    let options = vimonga#repo#document#options()
    let options['offset'] = float2nr(options['count'] / options['limit']) * options['limit']
    call vimonga#action#documents#find(a:params, options)
endfunction
