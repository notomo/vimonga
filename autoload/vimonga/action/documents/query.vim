
function! vimonga#action#documents#query#reset_all(params) abort
    let options = vimonga#repo#document#options({'query': {}})
    return vimonga#action#documents#find(a:params, options)
endfunction

function! vimonga#action#documents#query#add(params) abort
    let [key, value] = vimonga#buffer#documents#key_value(line('.'))
    if empty(key)
        return
    endif

    let options = vimonga#repo#document#options()
    let options['query'][key] = value

    return vimonga#action#documents#find(a:params, options)
endfunction
