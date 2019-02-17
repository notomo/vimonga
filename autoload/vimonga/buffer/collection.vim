
let s:filetype = 'vimonga-coll'

function! vimonga#buffer#collection#open_list(database_name) abort
    let database = vimonga#request#option('database', a:database_name)

    call s:open(['collection', database])
endfunction

function! vimonga#buffer#collection#open_list_by_index(index) abort
    let index = vimonga#request#option('index', a:index)

    call s:open(['collection', index])
endfunction

function! s:open(args) abort
    let result = vimonga#request#execute(a:args)
    let json = json_decode(result)
    let database_name = json['database_name']
    let collection_names = json['body']

    let path = printf('dbs/%s/colls', database_name)
    call vimonga#buffer#base#open(collection_names, s:filetype, path)
endfunction

function! vimonga#buffer#collection#open() abort
    if &filetype !=? s:filetype
        throw '&filetype must be ' . s:filetype . ' but actual: ' . &filetype
    endif

    call vimonga#buffer#document#find_by_index(line('.') - 1)
endfunction
