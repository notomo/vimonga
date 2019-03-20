
function! vimonga#command#execute(arg_string) abort
    let [args, params] = s:parse(a:arg_string)

    if empty(args)
        echohl ErrorMsg | echo 'no arguments' | echohl None | return
    endif

    let action = args[0]
    if action ==# 'database.list'
        call vimonga#action#databases#list('tabedit') | return
    endif

    echohl ErrorMsg | echo 'invalid argument: ' . a:arg_string | echohl None
endfunction

let s:param_mapper = {
    \ 'db': 'database_name',
    \ 'coll': 'collection_name',
\ }
function! s:parse(arg_string) abort
    let args = []
    let params = {}
    for factor in split(a:arg_string, '\v\s+')
        if stridx(factor, '=') != -1 && factor[0] ==# '-'
            let [key, value] = split(factor[1:], '=')
            if has_key(s:param_mapper, key)
                let mapped_key = s:param_mapper[key]
                let params[mapped_key] = value
            else
                echohl WarningMsg | echo 'invalid param: ' . factor | echohl None
            endif
            continue
        endif

        call add(args, factor)
    endfor

    return [args, params]
endfunction
