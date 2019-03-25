
function! vimonga#action#documents#projection#reset_all(params) abort
    let options = vimonga#repo#document#options({'projection': {}})
    call vimonga#action#documents#find(a:params, options)
endfunction

function! vimonga#action#documents#projection#hide(params) abort
    let field_name = vimonga#buffer#documents#field_name(line('.'))
    if empty(field_name)
        return
    endif
    let options = vimonga#repo#document#options()
    let options['projection'][field_name] = 0

    call vimonga#action#documents#find(a:params, options)
endfunction
