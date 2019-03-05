
let s:SEPARATER = '": '
let s:INDENT_SIZE = 2
function! vimonga#json#field_name(line_num) abort
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
    let parent_field = vimonga#json#field_name(parent_line_num)
    return parent_field . '.' . field_name
endfunction

function! vimonga#json#key_value(line_num) abort
    let key = vimonga#json#field_name(a:line_num)
    if empty(key)
        return ['', '']
    endif

    let line = getline(a:line_num)
    let indent = repeat(' ', indent(a:line_num))
    if line ==# printf('%s"%s": {', indent, key)
        let close_line_num = search('^' . indent . '}', 'n')
        let lines = getline(a:line_num + 1, close_line_num - 1)
        let value = json_decode('{' . join(lines, '') . '}')
        return [key, value]
    endif
    if line ==# printf('%s"%s": [', indent, key)
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
