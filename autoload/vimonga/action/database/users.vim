
function! vimonga#action#database#users#list(params) abort
    let database = vimonga#buffer#databases#model(a:params)
    let funcs = [{ -> vimonga#repo#user#list(database)}]
    call vimonga#buffer#database#users#open(funcs, a:params.open_cmd)
endfunction
