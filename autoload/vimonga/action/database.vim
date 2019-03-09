
function! vimonga#action#database#list(open_cmd) abort
    let [result, err] = vimonga#repo#database#list()
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    call vimonga#buffer#open_databases(result, a:open_cmd)
endfunction

function! vimonga#action#database#drop(open_cmd) abort
    let params = vimonga#buffer#ensure_databases()
    let database_name = params['database_name']

    if input('Drop ' . database_name . '? YES/n: ') !=# 'YES'
        redraw | echomsg 'Canceled'
        return
    endif

    let [result, err] = vimonga#repo#database#drop(database_name)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    let [result, err] = vimonga#repo#database#list()
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    call vimonga#buffer#open_databases(result, a:open_cmd)
endfunction
