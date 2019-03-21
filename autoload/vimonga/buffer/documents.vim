
let s:filetype = 'vimonga-docs'
function! vimonga#buffer#documents#filetype() abort
    return s:filetype
endfunction

function! vimonga#buffer#documents#ensure() abort
    call vimonga#buffer#impl#assert_filetype(s:filetype)
endfunction

function! vimonga#buffer#documents#open(funcs, open_cmd, options) abort
    let [result, err] = vimonga#buffer#impl#execute(a:funcs)
    if !empty(err)
        return vimonga#buffer#impl#error(err, a:open_cmd)
    endif
    call vimonga#buffer#impl#buffer(result['body'], s:filetype, result['path'], a:open_cmd)

    let b:vimonga_options = a:options
    let b:vimonga_options['limit'] = result['limit']
    let b:vimonga_options['is_first'] = result['offset'] == 0
    let b:vimonga_options['is_last'] = result['is_last'] ==# 'true'
    let b:vimonga_options['first_number'] = result['first_number']
    let b:vimonga_options['last_number'] = result['last_number']
    let b:vimonga_options['count'] = result['count']

    augroup vimonga_docs
        autocmd!
        autocmd BufReadCmd <buffer> Vimonga document.find
    augroup END
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
