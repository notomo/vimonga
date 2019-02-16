
let s:filetype = 'vimonga-db'

function! vimonga#buffer#database#open_list() abort
    let db_names = vimonga#request#execute(['database'])

    call vimonga#buffer#base#open(db_names, s:filetype)
endfunction

function! vimonga#buffer#database#open() abort
    if &filetype !=? s:filetype
        throw '&filetype must be ' . s:filetype . ' but actual: ' . &filetype
    endif

    call vimonga#buffer#collection#open_list_by_index(line('.') - 1)
endfunction
