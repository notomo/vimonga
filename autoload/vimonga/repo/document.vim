
function! vimonga#repo#document#find(database_name, collection_name, options) abort
    let database = vimonga#request#option('database', a:database_name)
    let collection = vimonga#request#option('collection', a:collection_name)

    let query = json_encode(a:options['query'])
    let projection = json_encode(a:options['projection'])
    let sort = json_encode(a:options['sort'])
    let option_args = [
        \ vimonga#request#option('query', query),
        \ vimonga#request#option('projection', projection),
        \ vimonga#request#option('sort', sort),
        \ vimonga#request#option('limit', a:options['limit']),
        \ vimonga#request#option('offset', a:options['offset']),
    \ ]

    let args = ['document', database, collection] + option_args + ['find']
    return vimonga#request#json(args)
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
