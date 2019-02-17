
let s:filetype = 'vimonga-doc'

function! vimonga#buffer#document#find(database_name, collection_name, ...) abort
    let database = vimonga#request#option('database', a:database_name)
    let collection = vimonga#request#option('collection', a:collection_name)
    let args = ['document', database, collection]
    if len(a:000) >= 1 && len(a:000[0]) > 0
        call extend(args, [vimonga#request#option('query', a:000[0])])
    endif
    if len(a:000) >= 2  && len(a:000[1]) > 0
        call extend(args, [vimonga#request#option('projection', a:000[1])])
    endif

    call s:open(args)
endfunction

function! vimonga#buffer#document#find_by_index(index) abort
    let database_name = fnamemodify(bufname('%'), ':h:t')
    let database = vimonga#request#option('database', database_name)
    let index = vimonga#request#option('index', a:index)

    call s:open(['document', index, database])
endfunction

function! s:open(args) abort
    let result = vimonga#request#execute(a:args)
    let json = json_decode(result)
    let documents = split(json['body'], '\%x00')
    let database_name = json['database_name']
    let collection_name = json['collection_name']

    let path = printf('dbs/%s/colls/%s/documents', database_name, collection_name)
    call vimonga#buffer#base#open(documents, s:filetype, path)
endfunction
