
function! vimonga#message#error(errs) abort
    echohl ErrorMsg
    for err in a:errs
         echomsg '[vimonga]: ' . err
    endfor
    echohl None
    return vimonga#job#err(a:errs)
endfunction

function! vimonga#message#confirm_strongly(message) abort
    let message = printf('%s YES/n: ', a:message)
    if input(message) !=# 'YES'
        redraw | return vimonga#job#err(['Canceled'])
    endif
    return vimonga#job#ok([])
endfunction

function! vimonga#message#confirm(message) abort
    let message = printf('%s y/n: ', a:message)
    if input(message) !=# 'y'
        redraw | return vimonga#job#err(['Canceled'])
    endif
    return vimonga#job#ok([])
endfunction

function! vimonga#message#input(message) abort
    let input = input(a:message)
    if empty(input)
        return vimonga#job#err(['Canceled'])
    endif
    return vimonga#job#ok(input)
endfunction
