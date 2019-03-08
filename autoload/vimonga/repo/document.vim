
function! vimonga#repo#document#find(database_name, collection_name, options) abort
    let database = vimonga#request#option('database', a:database_name)
    let collection = vimonga#request#option('collection', a:collection_name)
    return s:find([database, collection], a:options)
endfunction

function! vimonga#repo#document#find_by_number(database_name, options) abort
    let database = vimonga#request#option('database', a:database_name)
    let number = vimonga#request#number_option()
    return s:find([database, number], a:options)
endfunction

function! s:find(args, options) abort
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

    let pid = vimonga#request#pid_option()
    let args = ['document', pid] + a:args + option_args + ['find']
    return vimonga#request#json(args)
endfunction

function! vimonga#repo#document#options(options) abort
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

    return extend(extend(defaults, bufffer_options), a:options)
endfunction
