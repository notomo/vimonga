
function! vimonga#action#collection#indexes#list(params) abort
    let collection = vimonga#buffer#collections#model(a:params)
    let funcs = [{ -> vimonga#repo#index#list(collection)}]
    call vimonga#buffer#collection#indexes#open(funcs, a:params.open_cmd)
endfunction
