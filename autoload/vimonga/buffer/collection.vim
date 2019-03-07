
let s:filetype = 'vimonga-coll'
function! vimonga#buffer#collection#filetype() abort
    return s:filetype
endfunction

function! vimonga#buffer#collection#action_drop(open_cmd) abort
    call vimonga#buffer#assert_filetype(s:filetype)

    if input('Drop? YES/n: ') !=# 'YES'
        redraw
        echomsg 'Canceled'
        return
    endif

    let database_name = fnamemodify(bufname('%'), ':h:t')
    let [result, err] = vimonga#repo#collection#drop_by_number(database_name)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    let [result, err] = vimonga#repo#collection#list(database_name)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    call vimonga#buffer#open_collections(result, a:open_cmd)
endfunction

function! vimonga#buffer#collection#action_open_list(open_cmd) abort
    call vimonga#buffer#assert_filetype(vimonga#buffer#database#filetype())

    let [result, err] = vimonga#repo#collection#list_by_number()
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    call vimonga#buffer#open_collections(result, a:open_cmd)
endfunction

function! vimonga#buffer#collection#action_open_from_child(open_cmd) abort
    call vimonga#buffer#assert_filetype(
        \ vimonga#buffer#document#filetype(),
        \ vimonga#buffer#index#filetype(),
    \ )

    let database_name = fnamemodify(bufname('%'), ':h:h:h:t')
    let [result, err] = vimonga#repo#collection#list(database_name)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    call vimonga#buffer#open_collections(result, a:open_cmd)
endfunction
