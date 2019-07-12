
function! vimonga#message#error(errs) abort
    echohl ErrorMsg
    if vimonga#test#is_running()
        for err in a:errs
            call themis#log('[vimonga]: ' . err)
        endfor
    else
        for err in a:errs
            echomsg '[vimonga]: ' . err
        endfor
    endif
    echohl None
    return vimonga#job#err(a:errs)
endfunction

function! vimonga#message#warn(errs) abort
    echohl WarningMsg
    if vimonga#test#is_running()
        for err in a:errs
            call themis#log('[vimonga]: ' . err)
        endfor
    else
        for err in a:errs
            echomsg '[vimonga]: ' . err
        endfor
    endif
    echohl None
    return vimonga#job#err(a:errs)
endfunction

function! vimonga#message#confirm_strongly(message, force) abort
    if a:force
        return vimonga#job#ok([])
    endif
    let message = printf('%s YES/n: ', a:message)
    if input(message) !=# 'YES'
        redraw | return vimonga#job#err(['Canceled'])
    endif
    return vimonga#job#ok([])
endfunction

function! vimonga#message#confirm(message, force) abort
    if a:force
        return vimonga#job#ok([])
    endif
    let message = printf('%s y/n: ', a:message)
    if input(message) !=# 'y'
        redraw | return vimonga#job#err(['Canceled'])
    endif
    return vimonga#job#ok([])
endfunction

function! vimonga#message#input(message, input) abort
    if !empty(a:input)
        return vimonga#job#ok(a:input)
    endif
    let input = input(a:message)
    if empty(input)
        return vimonga#job#err(['Canceled'])
    endif
    return vimonga#job#ok([input])
endfunction
