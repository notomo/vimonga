
let s:filetype = 'vimonga-indexes'
function! vimonga#buffer#index#filetype() abort
    return s:filetype
endfunction

function! vimonga#buffer#index#action_list(open_cmd) abort
    call vimonga#buffer#assert_filetype(vimonga#buffer#collection#filetype())

    let database_name = fnamemodify(bufname('%'), ':h:t')
    let database = vimonga#request#option('database', database_name)
    let number = vimonga#request#option('number', line('.') - 1)
    call s:open([number, database], a:open_cmd)
endfunction

function! s:open(args, open_cmd) abort
    let args = ['index'] + a:args + ['list']
    let result = vimonga#request#execute(args)

    let json = json_decode(result)
    let documents = split(json['body'], '\%x00')
    let database_name = json['database_name']
    let collection_name = json['collection_name']

    let path = printf('dbs/%s/colls/%s/index', database_name, collection_name)
    call vimonga#buffer#open(documents, s:filetype, path, a:open_cmd)
endfunction
