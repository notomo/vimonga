
let s:filetype = 'vimonga-doc'
function! vimonga#buffer#document#filetype() abort
    return s:filetype
endfunction

function! vimonga#buffer#document#action_find(open_cmd) abort
    call vimonga#buffer#assert_filetype(vimonga#buffer#collection#filetype())

    let database_name = fnamemodify(bufname('%'), ':h:t')
    let database = vimonga#request#option('database', database_name)
    let number = vimonga#request#number_option()
    call s:open([number, database], {}, a:open_cmd)
endfunction

function! vimonga#buffer#document#action_query_reset_all() abort
    let options = s:options()
    if !has_key(options, 'query')
        return
    endif
    unlet options['query']

    call s:open_from_doc(options, 'edit')
endfunction

function! vimonga#buffer#document#action_query_add() abort
    let options = s:options()
    if !has_key(options, 'query')
        let options['query'] = {}
    endif

    let [key, value] = vimonga#json#key_value(line('.'))
    if empty(key)
        return
    endif

    let options['query'][key] = value
    call s:open_from_doc(options, 'edit')
endfunction

function! vimonga#buffer#document#action_projection_reset_all() abort
    let options = s:options()
    if !has_key(options, 'projection')
        return
    endif
    unlet options['projection']

    call s:open_from_doc(options, 'edit')
endfunction

function! vimonga#buffer#document#action_projection_hide() abort
    let options = s:options()
    if !has_key(options, 'projection')
        let options['projection'] = {}
    endif

    let field_name = vimonga#json#field_name(line('.'))
    if empty(field_name)
        return
    endif

    let options['projection'][field_name] = 0

    call s:open_from_doc(options, 'edit')
endfunction

function! vimonga#buffer#document#action_sort_toggle() abort
    let options = s:options()
    if !has_key(options, 'sort')
        let options['sort'] = {}
    endif

    let field_name = vimonga#json#field_name(line('.'))
    if empty(field_name)
        return
    endif

    if !has_key(options['sort'], field_name)
        let options['sort'][field_name] = -1
    else
        let options['sort'][field_name] = options['sort'][field_name] * -1
    endif
    let options['offset'] = 0

    call s:open_from_doc(options, 'edit')
endfunction

function! vimonga#buffer#document#action_sort(sort_direction) abort
    let options = s:options()
    if !has_key(options, 'sort')
        let options['sort'] = {}
    endif

    let field_name = vimonga#json#field_name(line('.'))
    if empty(field_name)
        return
    endif

    if a:sort_direction == 0 && !has_key(options['sort'], field_name)
        return
    elseif a:sort_direction == 0
        unlet options['sort'][field_name]
    else
        let options['sort'][field_name] = a:sort_direction
    endif
    let options['offset'] = 0

    call s:open_from_doc(options, 'edit')
endfunction

function! vimonga#buffer#document#action_sort_reset_all() abort
    let options = s:options()
    if !has_key(options, 'sort')
        return
    endif
    unlet options['sort']
    let options['offset'] = 0

    call s:open_from_doc(options, 'edit')
endfunction

function! vimonga#buffer#document#action_move_page(open_cmd, direction) abort
    let options = s:options()
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

    call s:open_from_doc(options, 'edit')
endfunction

function! s:open_from_doc(options, open_cmd) abort
    call vimonga#buffer#assert_filetype(s:filetype)

    let database_name = fnamemodify(bufname('%'), ':h:h:h:t')
    let database = vimonga#request#option('database', database_name)
    let collection_name = fnamemodify(bufname('%'), ':h:t')
    let collection = vimonga#request#option('collection', collection_name)

    call s:open([database, collection], a:options, a:open_cmd)
endfunction

function! s:open(args, options, open_cmd) abort
    let option_args = []
    if has_key(a:options, 'query')
        let query = json_encode(a:options['query'])
        call add(option_args, vimonga#request#option('query', query))
    endif
    if has_key(a:options, 'projection')
        let projection = json_encode(a:options['projection'])
        call add(option_args, vimonga#request#option('projection', projection))
    endif
    if has_key(a:options, 'sort')
        let sort = json_encode(a:options['sort'])
        call add(option_args, vimonga#request#option('sort', sort))
    endif
    if has_key(a:options, 'limit')
        call add(option_args, vimonga#request#option('limit', a:options['limit']))
    endif
    if has_key(a:options, 'offset')
        call add(option_args, vimonga#request#option('offset', a:options['offset']))
    endif

    let pid = vimonga#request#pid_option()
    let args = ['document', pid] + a:args + option_args + ['find']
    let [result, err] = vimonga#request#json(args)
    if !empty(err)
        return vimonga#buffer#error(err, a:open_cmd)
    endif

    let documents = result['body']
    let path = result['path']

    call vimonga#buffer#open(documents, s:filetype, path, a:open_cmd)
    let b:vimonga_options = a:options
    let b:vimonga_options['is_first'] = result['offset'] == 0
    let b:vimonga_options['is_last'] = result['is_last'] ==# 'true'
    let b:vimonga_options['first_number'] = result['first_number']
    let b:vimonga_options['last_number'] = result['last_number']
    let b:vimonga_options['count'] = result['count']
endfunction

function! s:options() abort
    if exists('b:vimonga_options')
        return b:vimonga_options
    endif
    return {}
endfunction
