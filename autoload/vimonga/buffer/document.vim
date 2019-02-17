
let s:filetype = 'vimonga-doc'
function! vimonga#buffer#document#filetype() abort
    return s:filetype
endfunction

function! vimonga#buffer#document#find(database_name, collection_name, ...) abort
    let database = vimonga#request#option('database', a:database_name)
    let collection = vimonga#request#option('collection', a:collection_name)
    let args = [database, collection]
    if len(a:000) >= 1 && len(a:000[0]) > 0
        call extend(args, [vimonga#request#option('query', a:000[0])])
    endif
    if len(a:000) >= 2  && len(a:000[1]) > 0
        call extend(args, [vimonga#request#option('projection', a:000[1])])
    endif
    call s:open(args, 'tabedit')
endfunction

function! vimonga#buffer#document#action_find(open_cmd) abort
    call vimonga#buffer#base#assert_filetype(vimonga#buffer#collection#filetype())

    let database_name = fnamemodify(bufname('%'), ':h:t')
    let database = vimonga#request#option('database', database_name)
    let index = vimonga#request#option('index', line('.') - 1)
    call s:open([index, database], a:open_cmd)
endfunction

function! s:open(args, open_cmd) abort
    let result = vimonga#request#execute(['document'] + a:args)

    let json = json_decode(result)
    let documents = split(json['body'], '\%x00')
    let database_name = json['database_name']
    let collection_name = json['collection_name']

    let path = printf('dbs/%s/colls/%s/documents', database_name, collection_name)
    call vimonga#buffer#base#open(documents, s:filetype, path, a:open_cmd)
endfunction
