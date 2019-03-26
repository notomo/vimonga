
function! vimonga#repo#document#find(collection, options) abort
    let database = vimonga#repo#impl#option('database', a:collection.database_name)
    let collection = vimonga#repo#impl#option('collection', a:collection.name)

    let query = json_encode(a:options['query'])
    let projection = json_encode(a:options['projection'])
    let sort = json_encode(a:options['sort'])
    let option_args = [
        \ vimonga#repo#impl#option('query', query),
        \ vimonga#repo#impl#option('projection', projection),
        \ vimonga#repo#impl#option('sort', sort),
        \ vimonga#repo#impl#option('limit', a:options['limit']),
        \ vimonga#repo#impl#option('offset', a:options['offset']),
    \ ]

    let args = ['document', database, collection] + ['find'] + option_args 
    return vimonga#repo#impl#execute(args)
endfunction

function! vimonga#repo#document#find_by_id(document) abort
    let database = vimonga#repo#impl#option('database', a:document.database_name)
    let collection = vimonga#repo#impl#option('collection', a:document.collection_name)
    let id = vimonga#repo#impl#option('id', a:document.id)
    let args = ['document', database, collection, 'get', id]
    return vimonga#repo#impl#execute(args)
endfunction

function! vimonga#repo#document#update(document, content) abort
    let database = vimonga#repo#impl#option('database', a:document.database_name)
    let collection = vimonga#repo#impl#option('collection', a:document.collection_name)
    let id = vimonga#repo#impl#option('id', a:document.id)
    let content = vimonga#repo#impl#option('content', a:content)
    let args = ['document', database, collection, 'update', id, content]
    return vimonga#repo#impl#execute(args)
endfunction

function! vimonga#repo#document#insert(collection, content) abort
    let database = vimonga#repo#impl#option('database', a:collection.database_name)
    let collection = vimonga#repo#impl#option('collection', a:collection.name)
    let content = vimonga#repo#impl#option('content', a:content)
    let args = ['document', database, collection, 'insert', content]
    return vimonga#repo#impl#execute(args, v:true)
endfunction

function! vimonga#repo#document#delete(document) abort
    let database = vimonga#repo#impl#option('database', a:document.database_name)
    let collection = vimonga#repo#impl#option('collection', a:document.collection_name)
    let id = vimonga#repo#impl#option('id', a:document.id)
    let args = ['document', database, collection, 'delete', id]
    return vimonga#repo#impl#execute(args)
endfunction

function! vimonga#repo#document#options(...) abort
    let defaults = {
        \ 'query': {},
        \ 'projection': {},
        \ 'sort': {},
        \ 'limit': 10,
        \ 'offset': 0,
        \ 'is_last': v:false,
        \ 'count': 0,
    \ }

    let bufffer_options = {}
    if exists('b:vimonga_options')
        let bufffer_options = b:vimonga_options
    endif

    let merged = extend(defaults, bufffer_options)
    if len(a:000) == 0
        return merged
    endif
    return extend(merged, a:000[0])
endfunction
