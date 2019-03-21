
function! vimonga#action#indexes#list(params) abort
    let collection = vimonga#buffer#collections#model(a:params)
    let funcs = [{ -> vimonga#repo#index#list(collection)}]
    call vimonga#buffer#indexes#open(funcs, a:params.open_cmd)
endfunction
