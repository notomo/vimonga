
let s:filetype = 'vimonga-docs'

function! vimonga#buffer#documents#open(collection, open_cmd, options) abort
    let path = vimonga#buffer#documents#path(a:collection)
    let buf = vimonga#buffer#impl#buffer(s:filetype, path, a:open_cmd)

    augroup vimonga_docs
        autocmd!
        autocmd BufReadCmd <buffer> Vimonga document.find
    augroup END

    return vimonga#job#ok({'id': buf, 'collection': a:collection})
endfunction

function! vimonga#buffer#documents#path(collection) abort
    let coll = vimonga#buffer#collections#path(a:collection.database())
    return printf('%s/%s/docs', coll, a:collection.name)
endfunction

function! vimonga#buffer#documents#content(buffer, result, options) abort
    let buffer_options = a:options
    let buffer_options['limit'] = a:result['limit']
    let buffer_options['is_first'] = a:result['offset'] == 0
    let buffer_options['is_last'] = a:result['is_last'] ==# 'true'
    let buffer_options['first_number'] = a:result['first_number']
    let buffer_options['last_number'] = a:result['last_number']
    let buffer_options['count'] = a:result['count']
    call nvim_buf_set_var(a:buffer, 'vimonga_options', buffer_options)
    return vimonga#buffer#impl#content(a:buffer, a:result['body'])
endfunction

let s:SEPARATER = '": '
let s:INDENT_SIZE = 2
function! vimonga#buffer#documents#field_name(line_num) abort
    let line = getline(a:line_num)
    let index = stridx(line, s:SEPARATER)
    if index == -1
        return ''
    endif

    let field_name = trim(line[:index - 1])[1:]
    let indent = index - strlen(field_name) - 1
    if indent == s:INDENT_SIZE * 2
        return field_name
    endif

    let parent_line_num = search('^' . repeat(' ', indent - s:INDENT_SIZE) . '\S', 'bn')
    let parent_field = vimonga#buffer#documents#field_name(parent_line_num)
    return parent_field . '.' . field_name
endfunction

function! vimonga#buffer#documents#key_value(line_num) abort
    let key = vimonga#buffer#documents#field_name(a:line_num)
    if empty(key)
        return ['', '']
    endif

    let line = getline(a:line_num)
    let indent = repeat(' ', indent(a:line_num))
    let last_key = get(split(key, '\.'), -1)
    if line ==# printf('%s"%s": {', indent, last_key)
        let close_line_num = search('^' . indent . '}', 'n')
        let lines = getline(a:line_num + 1, close_line_num - 1)
        let value = json_decode('{' . join(lines, '') . '}')
        return [key, value]
    endif
    if line ==# printf('%s"%s": [', indent, last_key)
        let close_line_num = search('^' . indent . '\]', 'n')
        let lines = getline(a:line_num, close_line_num - 1)
        let value = values(json_decode('{' . join(lines, '') . ']}'))[0]
        return [key, value]
    endif

    if line[strlen(line)-1:] ==# ','
        let line = line[:-2]
    endif
    let value = values(json_decode('{' . line . '}'))[0]
    return [key, value]
endfunction

function! vimonga#buffer#documents#get_id() abort
    let indent = repeat(' ', s:INDENT_SIZE * 2)
    let line_num = search('^' . indent . '"_id": {', 'bn')
    if line_num != 0
        let oid_line = getline(line_num + 1)
        let id = values(json_decode('{' . oid_line . '}'))[0]
        return id
    endif

    let line_num = search('^' . indent . '"_id": {', 'n')
    if line_num != 0
        let oid_line = getline(line_num + 1)
        let id = values(json_decode('{' . oid_line . '}'))[0]
        return id
    endif

    return ''
endfunction
