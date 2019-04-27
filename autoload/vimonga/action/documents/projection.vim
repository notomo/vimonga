
function! vimonga#action#documents#projection#reset_all(params) abort
    let options = vimonga#buffer#documents#options({'projection': {}})
    return vimonga#action#documents#find(a:params, options)
endfunction

function! vimonga#action#documents#projection#hide(params) abort
    let field_name = vimonga#buffer#documents#field_name(line('.'))
    if empty(field_name)
        return
    endif
    let options = vimonga#buffer#documents#options()
    let options['projection'][field_name] = 0

    return vimonga#action#documents#find(a:params, options)
endfunction
