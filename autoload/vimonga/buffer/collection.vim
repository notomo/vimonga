
let s:filetype = 'vimonga-coll'
function! vimonga#buffer#collection#filetype() abort
    return s:filetype
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
    let [result, err] = vimonga#request#json(['collection'] + a:args + ['list'])
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    let database_name = result['database_name']
    let collection_names = result['body']

    let path = printf('dbs/%s/colls', database_name)
    call vimonga#buffer#open(collection_names, s:filetype, path, a:open_cmd)
endfunction
