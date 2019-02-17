
let s:filetype = 'vimonga-coll'
function! vimonga#buffer#collection#filetype() abort
    return s:filetype
endfunction

function! vimonga#buffer#collection#open_list(database_name) abort
    let database = vimonga#request#option('database', a:database_name)
    call s:open([database], 'tabedit')
endfunction

function! vimonga#buffer#collection#action_open_list(open_cmd) abort
    call vimonga#buffer#base#assert_filetype(vimonga#buffer#database#filetype())

    let index = vimonga#request#option('index', line('.') - 1)
    call s:open([index], a:open_cmd)
endfunction

function! vimonga#buffer#collection#action_open_from_doc(open_cmd) abort
    call vimonga#buffer#base#assert_filetype(vimonga#buffer#document#filetype())

    let database_name = fnamemodify(bufname('%'), ':h:h:h:t')
    let database = vimonga#request#option('database', database_name)
    call s:open([database], a:open_cmd)
endfunction

function! s:open(args, open_cmd) abort
    let result = vimonga#request#execute(['collection'] + a:args)

    let json = json_decode(result)
    let database_name = json['database_name']
    let collection_names = json['body']

    let path = printf('dbs/%s/colls', database_name)
    call vimonga#buffer#base#open(collection_names, s:filetype, path, a:open_cmd)
endfunction
