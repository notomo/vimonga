
function! vimonga#action#documents#sort#reset_all(params) abort
    let collection = vimonga#buffer#collections#model(a:params)
    let options = vimonga#repo#document#options({'sort': {}})
    let funcs = [{ -> vimonga#repo#document#find(collection, options)}]
    call vimonga#buffer#documents#open(funcs, a:params.open_cmd, options)
endfunction

function! vimonga#action#documents#sort#toggle(params) abort
    let collection = vimonga#buffer#collections#model(a:params)

    let field_name = vimonga#buffer#documents#field_name(line('.'))
    if empty(field_name)
        return
    endif

    let options = vimonga#repo#document#options()
    if !has_key(options['sort'], field_name)
        let options['sort'][field_name] = -1
    else
        let options['sort'][field_name] = options['sort'][field_name] * -1
    endif
    let options['offset'] = 0

    let funcs = [{ -> vimonga#repo#document#find(collection, options)}]
    call vimonga#buffer#documents#open(funcs, a:params.open_cmd, options)
endfunction

function! vimonga#action#documents#sort#do(params, direction) abort
    let collection = vimonga#buffer#collections#model(a:params)

    let field_name = vimonga#buffer#documents#field_name(line('.'))
    if empty(field_name)
        return
    endif

    let options = vimonga#repo#document#options()
    if a:direction == 0 && !has_key(options['sort'], field_name)
        return
    elseif a:direction == 0
        unlet options['sort'][field_name]
    else
        let options['sort'][field_name] = a:direction
    endif
    let options['offset'] = 0

    let funcs = [{ -> vimonga#repo#document#find(collection, options)}]
    call vimonga#buffer#documents#open(funcs, a:params.open_cmd, options)
endfunction
