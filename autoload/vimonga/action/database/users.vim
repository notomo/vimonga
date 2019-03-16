
function! vimonga#action#database#users#list(open_cmd) abort
    let params = vimonga#buffer#databases#ensure_name()
    let database_name = params['database_name']
    let funcs = [{ -> vimonga#repo#database#users(database_name)}]
    call vimonga#buffer#database#users#open(funcs, a:open_cmd)
endfunction
