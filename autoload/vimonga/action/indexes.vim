
function! vimonga#action#indexes#list(open_cmd) abort
    let collection = vimonga#buffer#collections#ensure_name()
    let funcs = [{ -> vimonga#repo#index#list(collection)}]
    call vimonga#buffer#indexes#open(funcs, a:open_cmd)
endfunction
