
function! vimonga#action#database#users#list(open_cmd) abort
    let database = vimonga#buffer#databases#ensure_name()
    let funcs = [{ -> vimonga#repo#database#users(database)}]
    call vimonga#buffer#database#users#open(funcs, a:open_cmd)
endfunction
