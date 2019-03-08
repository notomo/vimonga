
function! vimonga#buffer#index#action_list(open_cmd) abort
    call vimonga#buffer#ensure_collections()

    let database_name = fnamemodify(bufname('%'), ':h:t')
    let [result, err] = vimonga#repo#index#list_by_number(database_name)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    call vimonga#buffer#open_indexes(result, a:open_cmd)
endfunction
