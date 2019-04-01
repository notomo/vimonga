
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

function! vimonga#action#documents#query#find_by_oid(params) abort
    let field_name = vimonga#buffer#documents#field_name(line('.'))
    if empty(field_name)
        return
    endif

    let message = printf('field=%s, ObjectId?: ', field_name)
    let result = vimonga#message#input(message)
    if result.is_err
        return
    endif
    let [oid] = result.ok

    let options = vimonga#repo#document#options()
    let options['query'][field_name] = {'$oid': oid}

    return vimonga#action#documents#find(a:params, options)
endfunction
