
function! vimonga#buffer#database#list(open_cmd) abort
    let [result, err] = vimonga#repo#database#list()
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    call vimonga#buffer#open_databases(result, a:open_cmd)
endfunction
