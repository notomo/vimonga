
let s:suite = themis#suite('indexes')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call VimongaTestBeforeEach()
endfunction

function! s:suite.after_each()
    call VimongaTestAfterEach()
endfunction

function! s:suite.list()
    let id = vimonga#command#execute('index.list -db=example -coll=tests1')
    call VimongaWait(id, s:assert)

    let json = join(getbufline('%', 0, '$'), '')
    let name_index = stridx(json, '"name": "_id_",')
    call s:assert.not_equals(name_index, -1)
endfunction
