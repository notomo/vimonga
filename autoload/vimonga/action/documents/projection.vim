
function! vimonga#action#documents#projection#reset_all(open_cmd) abort
    let collection = vimonga#buffer#documents#ensure()
    let options = vimonga#repo#document#options({'projection': {}})
    let funcs = [{ -> vimonga#repo#document#find(collection, options)}]
    call vimonga#buffer#documents#open(funcs, a:open_cmd, options)
endfunction

function! vimonga#action#documents#projection#hide(open_cmd) abort
    let collection = vimonga#buffer#documents#ensure()

    let field_name = vimonga#buffer#documents#field_name(line('.'))
    if empty(field_name)
        return
    endif
    let options = vimonga#repo#document#options()
    let options['projection'][field_name] = 0

    let funcs = [{ -> vimonga#repo#document#find(collection, options)}]
    call vimonga#buffer#documents#open(funcs, a:open_cmd, options)
endfunction
