
let s:filetype = 'vimonga-coll'
function! vimonga#buffer#collection#filetype() abort
    return s:filetype
endfunction

function! vimonga#buffer#collection#action_drop() abort
    call vimonga#buffer#assert_filetype(s:filetype)

    if input('Drop? YES/n: ') !=# 'YES'
        redraw
        echomsg 'Canceled'
        return
    endif

    let number = vimonga#request#number_option()
    let pid = vimonga#request#pid_option()
    let database_name = fnamemodify(bufname('%'), ':h:t')
    let database = vimonga#request#option('database', database_name)
    let [result, err] = vimonga#request#json(['collection', pid, database, 'drop', number])
    if !empty(err)
        return vimonga#buffer#error(err, 'edit')
    endif

    call s:open([database], 'edit')
endfunction

function! vimonga#buffer#collection#action_open_list(open_cmd) abort
    call vimonga#buffer#assert_filetype(vimonga#buffer#database#filetype())

    let number = vimonga#request#number_option()
    call s:open([number], a:open_cmd)
endfunction

function! vimonga#buffer#collection#action_open_from_child(open_cmd) abort
    call vimonga#buffer#assert_filetype(
        \ vimonga#buffer#document#filetype(),
        \ vimonga#buffer#index#filetype(),
    \ )

    let database_name = fnamemodify(bufname('%'), ':h:h:h:t')
    let database = vimonga#request#option('database', database_name)
    call s:open([database], a:open_cmd)
endfunction

function! s:open(args, open_cmd) abort
    let pid = vimonga#request#pid_option()
    let [result, err] = vimonga#request#json(['collection', pid] + a:args + ['list'])
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    let collection_names = result['body']
    let path = result['path']

    call vimonga#buffer#open(collection_names, s:filetype, path, a:open_cmd)
endfunction
