
let s:filetype = 'vimonga-indexes'
function! vimonga#buffer#index#filetype() abort
    return s:filetype
endfunction

function! vimonga#buffer#index#action_list(open_cmd) abort
    call vimonga#buffer#assert_filetype(vimonga#buffer#collection#filetype())

    let database_name = fnamemodify(bufname('%'), ':h:t')
    let database = vimonga#request#option('database', database_name)
    let number = vimonga#request#number_option()
    call s:open([number, database], a:open_cmd)
endfunction

function! s:open(args, open_cmd) abort
    let pid = vimonga#request#pid_option()
    let args = ['index', pid] + a:args + ['list']
    let [result, err] = vimonga#request#json(args)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    let documents = result['body']
    let path = result['path']

    call vimonga#buffer#open(documents, s:filetype, path, a:open_cmd)
endfunction
