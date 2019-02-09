
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

    let documents = vimonga#request#execute(args)

    call vimonga#buffer#base#open(documents, 'vimonga-doc')
endfunction
