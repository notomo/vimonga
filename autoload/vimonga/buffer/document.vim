
let s:filetype = 'vimonga-doc'
function! vimonga#buffer#document#filetype() abort
    return s:filetype
endfunction

function! vimonga#buffer#document#find(database_name, collection_name, ...) abort
    let database = vimonga#request#option('database', a:database_name)
    let collection = vimonga#request#option('collection', a:collection_name)
    let args = [database, collection]
    let options = {}
    if len(a:000) > 0
        let options = a:000[0]
    endif
    call s:open(args, options, 'tabedit')
endfunction

function! vimonga#buffer#document#action_find(open_cmd) abort
    call vimonga#buffer#base#assert_filetype(vimonga#buffer#collection#filetype())

    let database_name = fnamemodify(bufname('%'), ':h:t')
    let database = vimonga#request#option('database', database_name)
    let index = vimonga#request#option('index', line('.') - 1)
    call s:open([index, database], {}, a:open_cmd)
endfunction

function! vimonga#buffer#document#action_move_page(open_cmd, direction) abort
    call vimonga#buffer#base#assert_filetype(s:filetype)

    let database_name = fnamemodify(bufname('%'), ':h:h:h:t')
    let database = vimonga#request#option('database', database_name)
    let collection_name = fnamemodify(bufname('%'), ':h:t')
    let collection = vimonga#request#option('collection', collection_name)
    let options = {}
    if exists('b:vimonga_options')
        let options = b:vimonga_options
    endif

    if has_key(options, 'is_last') && options['is_last'] && a:direction > 0
        return
    endif

    if !has_key(options, 'offset')
        let options['offset'] = 0
    endif

    if options['offset'] == 0 && a:direction < 0
        return
    endif

    if !has_key(options, 'limit')
        let options['limit'] = 10
    endif
    let options['offset'] += options['limit'] * a:direction
    if options['offset'] < 0
        let options['offset'] = 0
    endif

    call s:open([database, collection], options, a:open_cmd)
endfunction

function! s:open(args, options, open_cmd) abort
    let option_args = []
    if has_key(a:options, 'query')
        call add(option_args, vimonga#request#option('query', a:options['query']))
    endif
    if has_key(a:options, 'projection')
        call add(option_args, vimonga#request#option('projection', a:options['projection']))
    endif
    if has_key(a:options, 'limit')
        call add(option_args, vimonga#request#option('limit', a:options['limit']))
    endif
    if has_key(a:options, 'offset')
        call add(option_args, vimonga#request#option('offset', a:options['offset']))
    endif

    let args = ['document'] + a:args + option_args + ['find']
    let result = vimonga#request#execute(args)

    let json = json_decode(result)
    let documents = split(json['body'], '\%x00')
    let database_name = json['database_name']
    let collection_name = json['collection_name']
    let is_last = json['is_last'] ==# 'true'

    let path = printf('dbs/%s/colls/%s/docs', database_name, collection_name)
    call vimonga#buffer#base#open(documents, s:filetype, path, a:open_cmd)
    let b:vimonga_options = a:options
    let b:vimonga_options['is_last'] = is_last
endfunction
