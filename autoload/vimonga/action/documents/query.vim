
function! vimonga#action#documents#query#reset_all(open_cmd) abort
    let params = vimonga#buffer#documents#ensure()

    let options = vimonga#repo#document#options({'query': {}})

    let database_name = params['database_name']
    let collection_name = params['collection_name']
    let funcs = [{ -> vimonga#repo#document#find(database_name, collection_name, options)}]
    call vimonga#buffer#documents#open(funcs, a:open_cmd, options)
endfunction

function! vimonga#action#documents#query#add(open_cmd) abort
    let params = vimonga#buffer#documents#ensure()

    let [key, value] = vimonga#buffer#documents#key_value(line('.'))
    if empty(key)
        return
    endif

    let options = vimonga#repo#document#options()
    let options['query'][key] = value

    let database_name = params['database_name']
    let collection_name = params['collection_name']
    let funcs = [{ -> vimonga#repo#document#find(database_name, collection_name, options)}]
    call vimonga#buffer#documents#open(funcs, a:open_cmd, options)
endfunction
