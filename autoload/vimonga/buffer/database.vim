
let s:filetype = 'vimonga-db'

function! vimonga#buffer#database#open_list() abort
    let db_names = vimonga#request#execute(['database'])

    call vimonga#buffer#base#open(db_names, s:filetype)
endfunction
