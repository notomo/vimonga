
let s:filetype = 'vimonga-db'
function! vimonga#buffer#database#filetype() abort
    return s:filetype
endfunction

function! vimonga#buffer#database#action_open(open_cmd) abort
    call s:open([], a:open_cmd)
endfunction

function! s:open(args, open_cmd) abort
    let pid = vimonga#request#pid_option()
    let [result, err] = vimonga#request#json(['database', pid, 'list'] + a:args)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    let database_names = result['body']
    let path = result['path']

    call vimonga#buffer#open(database_names, s:filetype, path, a:open_cmd)
endfunction
